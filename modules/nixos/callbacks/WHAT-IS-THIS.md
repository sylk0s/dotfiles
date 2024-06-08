Hello there,

If you're reading this, it means you've probably came across this weird folder with strange modules and are wondering WTF could they possibly be doing here.
Never fear! I am here to explain.

This section is probably the most questionable thing in all of my configs.
Without getting too much into design philosophy, the best way to explain my delima is with an example:
(note, this is not meant to be a 1000% correct nix expression, just to get the idea across)

```nix
{...}: {
    options.module = {
        ...
    }

    config = mkIf config.module.enabled {
        home.packages = [ pkgs.xfce.thunar ];

        # any other config for thunar!
    };
}
```

In my setup, the desktop environment is managed under home-manager. Therefore, one user could have a desktop, and another could just have a shell.
`thunar` is the xfce file manager gui, so it would make sense to only install thunar for that user.
Therefore, `thunar` should be controlled using a module in `home-manager` right?

This all seems like a good idea until I decide I want to do a fairly innocuous thing like adding `tumbler`, a service which allows image previews.
In NixOS, there's a `services.tumbler.enable` option, however no option available in home-manager.

> Another place this shows up with udev rules. My embedded dev toolchain is controlled per user, but i don't wanna add the udev rules if no user has it configured. that seems extranious and unsafe! There are also a few other small places this shows up as well. Not enough to be a huge design problem, and honestly, if I cared less about doing this 100% in a way that makes sense to me, I would just bite the bullet and configure those things per host.

One last thing to note:
For reading the NixOS config in home-manager we can use `osConfig` (same as config in nixos modules), but this is immutable, and we can't modify any module options.
For reading the home-manager config for each user, we can use `config.home-manager.users.${user}.[insert option here]`. This is the tool we use here.

Anyways, now enters my solution, and an explaination for this folder!

Essentially, what I'm doing is this:
Each module in this folder is more or less trying to detect home-manager modules turning on, to provide some additional config for them.
It does this by essiantally doing the following `(any (user: (predicate) user) config.home-manager.users)`, where the predicate is checking if some module is enabled.

For example:
user A wants `thunar` and so enables it. this module will see that there exists a user that has enabled `thunar`, and then automatically provide the NixOS config required.

That's basically it. I couldn't really find a better solution working inside both my personal goals for this setup and the constraints of `home-manager` and NixOS.
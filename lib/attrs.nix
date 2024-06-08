{lib, ...}:
with builtins;
with lib; rec {
  # attrsToList
  attrsToList = attrs:
    mapAttrsToList (name: value: {inherit name value;}) attrs;

  # TODO remove these if not needed from the rest of the code

  # anyAttrs :: (name -> value -> bool) attrs
  anyAttrs = pred: attrs:
    any (attr: pred attr.name attr.value) (attrsToList attrs);

  # countAttrs :: (name -> value -> bool) attrs
  countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value) (attrsToList attrs);

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  filterMapAttrs = pred: f: attrs: mapAttrs' f (filterAttrs pred attrs);
}

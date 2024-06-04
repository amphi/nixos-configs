{ homeManagerModules, ...}:
{
  imports = builtins.attrValues homeManagerModules;
}

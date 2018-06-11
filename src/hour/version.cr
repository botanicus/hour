require "yaml"

class Hour
  RAW_PKG_DATA = {% begin %}"{{system("cat shard.yml")}}"{% end %}
  #PACKAGE = NamedTuple(String, String | Array(String)).new(YAML.parse(RAW_PKG_DATA))
  #VERSION = PACKAGE[:version]
  PACKAGE = YAML.parse(RAW_PKG_DATA)
  VERSION = PACKAGE["version"]
end

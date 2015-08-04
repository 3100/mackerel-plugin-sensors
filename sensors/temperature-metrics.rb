# 識別用
name = 'temperature'
input = `sensors`

# sensorsの出力形式からラベル名と温度値のハッシュ表を返す
# キーが重複することは考慮していない
def create_hash(input)
  h = {}
  reg = Regexp.new("(.+):\s+([+-][0-9.]+)°C ")
  input.each_line{|line|
    res = reg.match(line)
    if res
      h[res[1]] = to_value(res[2])
    end
  }
  h
end

def generate_meta_metrics(input)
  h = create_hash(input)
  h.keys.map{|key|
    {:name => to_name(key.to_s), :label => key }
  }
end

# Mackerel用出力形式のnameに相当
def to_name(str)
  str.gsub(/\s/, "").downcase
end

# 数値への変換
def to_value(str)
  # 符号も対応してくれてる様子
  str.to_f
end

if ENV['MACKEREL_AGENT_PLUGIN_META'] == '1'
  require 'json'

  meta = {
    :graphs => {
      name => {
        :label => 'Temperature',
        :unit  => 'float',
        :metrics => generate_meta_metrics(input)
      }
    }
  }

  puts '# mackerel-agent-plugin'
  puts meta.to_json
  exit 0
end

res = create_hash(input)
res.each {|label, temp|
  puts [ "#{name}.#{to_name(label)}", temp, Time.now.to_i].join("\t")
}

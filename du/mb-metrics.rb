require 'pathname'

input = `du --block-size=1M /home --max-depth=1`

def create_hash(input)
  ex = ['lost+found', 'tmp', 'graph', 'volumes', 'home']
  h = {}
  input.each_line{|line|
    res = line.split
    key = Pathname(res[1]).basename.to_s
    unless ex.include?(key) then
      h[key] = res[0].to_i
    end
  }
  h
end

def generate_meta_metrics(input)
  h = create_hash(input)
  h.keys.map{|k|
    {:name => k, :label => k.upcase}
  }
end

#if $0 == __FILE__
  if ENV['MACKEREL_AGENT_PLUGIN_META'] == '1'
    require 'json'

    meta = {
      :graphs => {
        'mb' =>  {
        :label => 'MB',
        :unit => 'integer',
        :metrics => generate_meta_metrics(input)
        }
      }
    }

    puts '# mackerel-agent-plugin'
    puts meta.to_json
    exit 0
  end

  res = create_hash(input)
  res.each {|label, val|
    puts [ "mb.#{label}", val, Time.now.to_i ].join("\t")
  }
#end

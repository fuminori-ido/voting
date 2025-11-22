package 'imagemagick'

# = create /var/opt/voting/data/ENV/

directory (Pathname.new('/var/opt') + Wtech.app).to_s do
  owner   Wtech.user
  group   Wtech.group
  mode    '775'
end

directory (Pathname.new('/var/opt') + Wtech.app + 'data').to_s do
  owner   Wtech.user
  group   Wtech.group
  mode    '775'
end

for env in %w(dev test perf prod) do
  directory (Pathname.new('/var/opt') + Wtech.app + 'data' + env).to_s do
    owner   Wtech.user
    group   Wtech.group
    mode    '775'
  end
end


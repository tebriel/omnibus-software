name "pycrypto"
default_version "2.6.1"

dependency "python"
dependency "pip"

if ohai['platform'] == 'windows'
  dependency 'vc_python'
end

build do
  pip "install -I #{name}==#{version}"
end

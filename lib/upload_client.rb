require 'drb'
DRb.start_service("druby://localhost:0")

def get_status
  DRbObject.new nil, 'druby://0.0.0.0:2999'
end
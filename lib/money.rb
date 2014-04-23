class Money
  def to_json(options = nil)
    options && options[:encode_money_as_number]? to_f.to_s : to_s
  end
end
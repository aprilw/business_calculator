class Calculator
  def initialize
    @categorized_totals = blank_totals
    @rows_parsed = []
  end

  def blank_totals
    Hash.new do |hash, key|
      hash[key] = { revenues: { categories: Hash.new{ |h,k| h[k] = 0.to_money },
                                total: 0.to_money},
                    expenses: { categories: Hash.new{ |h,k| h[k] = 0.to_money },
                                total: 0.to_money}
                  }
    end
  end

  def process_csv(file)
    CSV.foreach(file, headers: true, header_converters: :symbol, skip_blanks: true) do |row|
      if row.first.all? # skip lines without a year
        row = row.to_hash
        update_rows_parsed(row)
        update_categorized_totals(row)
      end
    end

    construct_json
  end

  def update_rows_parsed(row)
    @rows_parsed << [row[:year].to_i,
                     row[:month].to_i,
                     row[:category_id],
                     row[:category_name],
                     row[:item_name],
                     row[:amount].to_f]
  end

  def update_categorized_totals(row)
    amount = row[:amount].to_money
    type, opposite_type = determine_type(amount)

    @categorized_totals[row[:year]][type][:categories][row[:category_name]] += amount

    # ensure every fund or dept listed in expenses shows up in revenues and vice versa
    @categorized_totals[row[:year]][opposite_type][:categories][row[:category_name]] ||= 0.to_money

    @categorized_totals[row[:year]][type][:total] += amount
  end

  def determine_type(amount)
    amount > 0 ? [:revenues, :expenses] : [:expenses, :revenues]
  end

  def construct_json
    { rows_parsed: @rows_parsed,
      categorized_totals: @categorized_totals }.to_json(encode_money_as_number: true)
  end
end
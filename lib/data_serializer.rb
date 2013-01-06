require 'json'

# special serializer which turns any nested Hash into a Hash with sorted, symbolized keys
# and any nil values removed
# SortedSymbolKeyHash
class DataSerializer
  def self.dump(hash)
    hash ||= {}
    ::JSON.dump sort_and_sym_keys(hash)
  end

  def self.load(json)
    return {} if json.nil?
    sort_and_sym_keys ::JSON.load(json)
  end

  private
  def self.sort_and_sym_keys(data)
    unless data.is_a?(Hash)
      data
    else
      sorted_keys(data).inject({}) do |hash, key|
        if (value = sort_and_sym_keys(data[key])) && !value.blank?
          hash[key.to_sym] = value
        end
        hash
      end
    end
  end

  def self.sorted_keys(hash)
    hash.keys.sort { |a,b| a.to_sym <=> b.to_sym }
  end
end

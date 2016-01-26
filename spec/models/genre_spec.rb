require 'spec_helper'

describe Genre do
  describe '::find_or_create_by_csv_string' do
    it 'accepts a CSV string and creates or finds the genres by name' do
      Genre.create(:name => "pop")

      expect{Genre.find_or_create_by_csv_string("pop, rock")}
    end
  end
end

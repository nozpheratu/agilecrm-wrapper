require 'spec_helper'

describe AgileCRMWrapper::Tag do
  describe '.all' do
    subject { AgileCRMWrapper::Tag.all }

    it 'should return an array of Tags' do
      expect(subject.map(&:class).uniq).to eq([AgileCRMWrapper::Tag])
    end
  end
end

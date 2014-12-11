require 'spec_helper'

describe AgileCRMWrapper::Note do
  describe '.create' do
    it 'creates a new note' do
      expect(
        AgileCRMWrapper::Note.create(123, subject: '', description: '')
      ).to be_kind_of(AgileCRMWrapper::Note)
    end
  end
end

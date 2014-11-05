require 'spec_helper'

describe AgileCRM::Note do
  describe '.create' do
    it 'creates a new note' do
      expect(
        AgileCRM::Note.create(123, subject: '', description: '')
      ).to be_kind_of(AgileCRM::Note)
    end
  end
end

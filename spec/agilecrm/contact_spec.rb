require 'spec_helper'

describe AgileCRM::Contact do

  describe '.all' do
    subject { AgileCRM::Contact.all }

    it "should return an array of Contacts" do
      expect(subject.map(&:class).uniq).to eq([AgileCRM::Contact])
    end
  end

  describe '.find' do
    let(:id) { 123 }
    subject { AgileCRM::Contact.find(id) }

    context 'given an existing contact ID' do
      it { should be_kind_of(AgileCRM::Contact) }

      its(:id) { should eq 123 }
    end

    context 'given an unknown contact ID' do
      let(:id) { 0 }
      it { expect{ is_expected.to raise_error(AgileCRM::NotFound) } }
    end
  end

  describe '.create' do
    subject {
      AgileCRM::Contact.create(
        tags: ['sales', 'rspec'], first_name: 'Anita',
        last_name: 'Drink', email: 'anitadrink@example.com', custom_field: 'Im a custom field!'
      )
    }

    its(:status) { should eq 201 }
  end

  describe '.delete' do
    context 'given a single ID' do
      subject { AgileCRM::Contact.delete(123) }

      its(:status) { should eq 204 }
    end
  end

  describe '#destroy' do
    let(:contact) { AgileCRM::Contact.find(123) }
    subject { contact.destroy }

    its(:status) { should eq 204 }
  end
end

require 'spec_helper'

describe AgileCRM::Contact do

  describe '.all' do
    subject { AgileCRM::Contact.all }

    it 'should return an array of Contacts' do
      expect(subject.map(&:class).uniq).to eq([AgileCRM::Contact])
    end
  end

  describe '.find' do
    let(:id) { 123 }
    subject { AgileCRM::Contact.find(id) }

    context 'given an existing contact ID' do
      it { should be_kind_of(AgileCRM::Contact) }

      its(:id) { should eq id }
    end

    context 'given an unknown contact ID' do
      let(:id) { 0 }
      it { expect { is_expected.to raise_error(AgileCRM::NotFound) } }
    end
  end

  describe '.delete' do
    context 'given a single ID' do
      subject { AgileCRM::Contact.delete(123) }

      its(:status) { should eq 204 }
    end
  end

  describe '.search_by_email' do
    let(:email) { 'anitadrink@example.com' }
    subject { AgileCRM::Contact.search_by_email(email) }

    context 'given an existing email' do
      it 'should return a contact with the corresponding email' do
        expect(subject.get_property('email')).to eq email
      end
    end

    context 'given an non-existing email' do
      let(:email) { 'idontexist@example.com' }

      it 'should return an empty array' do
        expect(subject).to eq nil
      end
    end
  end

  describe '.create' do
    subject do
      AgileCRM::Contact.create(
        tags: %w(sales, rspec), first_name: 'Anita',
        last_name: 'Drink', email: 'anitadrink@example.com',
        custom_field: 'Im a custom field!'
      )
    end

    its(:status) { should eq 201 }
  end

  describe '#update' do
    let(:contact) { AgileCRM::Contact.find(123) }

    it 'updates the receiving contact with the supplied key-value pair(s)' do
      expect do
        contact.update(first_name: 'Foo!')
      end.to change{
        contact.get_property('first_name')
      }.from('Anita').to('Foo!')
    end
  end

  describe '#get_property' do
    let(:contact) { AgileCRM::Contact.find(123) }

    context 'supplied an existing property name' do
      it 'returns the value' do
        expect(contact.get_property('email')).to_not be_nil
      end
    end

    context 'supplied a non-existing property name' do
      it 'returns nil' do
        expect(contact.get_property('nil-propety')).to be_nil
      end
    end
  end

  describe '#destroy' do
    let(:contact) { AgileCRM::Contact.find(123) }
    subject { contact.destroy }

    its(:status) { should eq 204 }
  end
end

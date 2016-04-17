require 'spec_helper'

describe AgileCRMWrapper::Contact do
  let(:contact) { AgileCRMWrapper::Contact.find(123) }

  describe '.all' do
    subject { AgileCRMWrapper::Contact.all }

    it 'should return an array of Contacts' do
      expect(subject.map(&:class).uniq).to eq([AgileCRMWrapper::Contact])
    end
  end

  describe '.find' do
    let(:id) { 123 }
    subject { AgileCRMWrapper::Contact.find(id) }

    context 'given an existing contact ID' do
      it { should be_kind_of(AgileCRMWrapper::Contact) }

      its(:id) { should eq id }
    end

    context 'given an unknown contact ID' do
      let(:id) { 0 }
      it { expect { is_expected.to raise_error(AgileCRMWrapper::NotFound) } }
    end
  end

  describe '.delete' do
    context 'given a single ID' do
      subject { AgileCRMWrapper::Contact.delete(123) }

      its(:status) { should eq 204 }
    end
  end

  describe '#delete_tags' do
    it 'removes the tags' do
      expect(
        contact.delete_tags(['sales'])
      ).to eq ['rspec', 'new']
    end
  end

  describe '.search_by_email' do
    let(:email) { 'anitadrink@example.com' }
    subject { AgileCRMWrapper::Contact.search_by_email(email) }

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

  describe '.search' do
    let(:name) { 'Anita' }
    subject { AgileCRMWrapper::Contact.search(name) }

    it 'should return a contact by matching any field' do
      expect(subject[0].get_property('user_name')).to eq name
    end
  end

  describe '.create' do
    subject do
      AgileCRMWrapper::Contact.create(
        tags: %w(sales, rspec), first_name: 'Anita',
        last_name: 'Drink', email: 'anitadrink@example.com',
        custom_field: 'Im a custom field!'
      )
    end

    its(:class) { should eq AgileCRMWrapper::Contact }
  end

  describe '#notes' do
    it 'returns the associated notes' do
      expect(contact.notes.map(&:class).uniq).to eq [AgileCRMWrapper::Note]
    end
  end

  describe '#update' do

    it 'updates the receiving contact with the supplied key-value pair(s)' do
      expect do
        contact.update(first_name: 'Foo!')
      end.to change{
        contact.get_property('first_name')
      }.from('Anita').to('Foo!')
    end
  end

  describe '#get_property' do
    let(:contact) { AgileCRMWrapper::Contact.find(123) }

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

    context 'two properties share the same name' do
      it 'returns an array' do
        expect(contact.get_property('phone_number').class).to eq(Array)
      end
    end
  end

  describe '#change_owner' do
    let(:contact) { AgileCRMWrapper::Contact.find(123) }

    context 'given existing user' do
      it 'updates owner' do
        contact.change_owner('new_owner@example.com')
        expect(contact.owner.email).to eq('new_owner@example.com')
      end
    end

    context 'given non-existing user' do
      it 'raises error' do
        expect{
          contact.change_owner('idontexist@example.com')
        }.to raise_error(AgileCRMWrapper::NotFound)
      end
    end
  end

  describe '#destroy' do
    let(:contact) { AgileCRMWrapper::Contact.find(123) }
    subject { contact.destroy }

    its(:status) { should eq 204 }
  end
end

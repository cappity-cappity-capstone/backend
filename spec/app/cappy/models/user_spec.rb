require 'spec_helper'
require 'date'

describe Cappy::Models::User do
  describe '#valid?' do
    let(:username) { 'admin' }
    let(:password) { 'admins_password' }

    subject { described_class.new(username: username, password: password) }

    context 'when the username is nil' do
      let(:username) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when the username is not nil' do
      context 'but the password is nil' do
        let(:password) { nil }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end

      context 'and the password is not nil' do
        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end
  end
end

require 'spec_helper'
require 'date'

describe Cappy::Models::User do
  describe '#valid?' do
    let(:username) { 'admin' }
    let(:password_hash) { 'password_hash' }

    subject { described_class.new(username: username, password_hash: password_hash) }

    context 'when the username is nil' do
      let(:username) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'when the username is not nil' do
      context 'but the password_hash is nil' do
        let(:password_hash) { nil }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end
      end

      context 'and the password_hash is not nil' do
        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end
  end
end

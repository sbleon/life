require_relative '../lib/cell'

describe Cell do
  describe 'living cell' do
    subject { Cell.new(true) }

    it {subject.fate(1).should be_false}
    it {subject.fate(2).should be_true}
    it {subject.fate(3).should be_true}
    it {subject.fate(4).should be_false}
    it {subject.fate(5).should be_false}
    it {subject.fate(6).should be_false}
    it {subject.fate(7).should be_false}
    it {subject.fate(8).should be_false}

    it {subject.alive?.should be_true}
    it {subject.dead?.should be_false}
  end

  describe 'dead cell' do
    subject { Cell.new(false) }

    it {subject.fate(1).should be_false}
    it {subject.fate(2).should be_false}
    it {subject.fate(3).should be_true}
    it {subject.fate(4).should be_false}
    it {subject.fate(5).should be_false}
    it {subject.fate(6).should be_false}
    it {subject.fate(7).should be_false}
    it {subject.fate(8).should be_false}

    it {subject.alive?.should be_false}
    it {subject.dead?.should be_true}
  end
end
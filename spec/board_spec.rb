require_relative '../lib/board'

describe Board do
  subject {Board.new(0)}

  describe 'initializes' do
    it 'with a seed' do
      subject = Board.new(7)
      subject.living_cell_coordinates.sort.should == [[2,-2],[1,-2],[0,-2]].sort
    end
  end

  describe 'sets and gets cell states' do
    it 'for set cells' do
      subject.set(0, 0, true)
      subject.get_state(0, 0).should be_true
      subject.set(1, 1, false)
      subject.get_state(1, 1).should be_false
      subject.set(2, -1, true)
      subject.get_state(2, -1).should be_true
    end

    it 'for unset cells' do
      subject.get_state(3, 3).should be_false
    end
  end

  describe 'gets cells' do
    it 'for set cells' do
      subject.set(0, 0, true)
      subject.get_cell(0, 0).class.should == Cell
      subject.get_cell(0, 0).state.should be_true
    end

    it 'for unset cells' do
      subject.get_cell(1, 1).class.should == Cell
      subject.get_cell(1, 1).state.should be_false
    end
  end

  describe 'reports living cell coordinates' do
    it 'reports none for an empty board' do
      subject.living_cell_coordinates.should == []
    end

    it 'reports cells that are alive' do
      subject.set(0, 0, true)
      subject.set(0, 1, true)
      subject.set(0, 2, true)
      subject.set(0, 3, false)
      subject.living_cell_coordinates.sort.should == [[0,0],[0,1],[0,2]].sort
    end
  end

  describe 'ticks to the next state' do

    describe 'blinker' do
      before do
        subject.set(0, 0, true)
        subject.set(0, 1, true)
        subject.set(0, 2, true)
      end

      it 'changes to a vertical blinker' do
        subject.tick

        subject.get_state(0, 0).should be_false
        subject.get_state(0, 1).should be_true
        subject.get_state(0, 2).should be_false
        subject.get_state(-1, 1).should be_true
        subject.get_state(1, 1).should be_true
      end

      it 'changes back to a horizontal blinker' do
        subject.tick
        subject.tick

        subject.get_state(0, 0).should be_true
        subject.get_state(0, 1).should be_true
        subject.get_state(0, 2).should be_true
        subject.get_state(-1, 1).should be_false
        subject.get_state(1, 1).should be_false
      end
    end

  end
end
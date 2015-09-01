require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new (8) { EmptySquare.new } }
    setup
  end

  def move(start, end_pos)
    # raise BadMoveError.new, "there's nothing at #{start}" if self[start].is_a?(EmptySquare)
    self[end_pos] = self[start]
    #
    # raise BadMoveError.new, "can't move there" unless self[start].valid_move(end_pos)?
    self[start] = EmptySquare.new
    #return true or false to PLayer depending on if move succeeded
  end

  def setup
    # if color == white
    #   board = self.reverse
    # else
    #   board = self
    # end

    grid[1].each_with_index do |piece, index| # this doesn't work yet
      place_piece(:black, [1,index], Pawn)
    end

    grid[6].each_with_index do |piece, index| # ditto
      place_piece(:white, [6,index], Pawn)
    end

    place_piece(:black, [0,0], Rook)
    place_piece(:black, [0,7], Rook)
    place_piece(:black, [0,1], Knight)
    place_piece(:black, [0,6], Knight)
    place_piece(:black, [0,2], Bishop)
    place_piece(:black, [0,5], Bishop)
    place_piece(:black, [0,3], Queen)
    place_piece(:black, [0,4], King)

    place_piece(:white, [7,0], Rook)
    place_piece(:white, [7,6], Rook)
    place_piece(:white, [7,1], Knight)
    place_piece(:white, [7,7], Knight)
    place_piece(:white, [7,2], Bishop)
    place_piece(:white, [7,5], Bishop)
    place_piece(:white, [7,3], Queen)
    place_piece(:white, [7,4], King)



  end

  def place_piece(color, pos, piece)
    self[pos] = piece.new(color, pos, self)
  end


  def dup # duplicate board and its pieces
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    grid[x][y] = val
  end

  def in_bounds?(pos)
    pos.each do |coord|
      return false if coord > 7
      return false if coord < 0
    end
    return true
  end

end

class BadMoveError < StandardError

end
require './pieces/pieces-manifest.rb'
require_relative 'castleable.rb'
require_relative 'promotable.rb'

class Board
  include Castleable
  include Promotable
  attr_accessor :grid, :captured_pieces

  def initialize
    @grid = Array.new(8) { Array.new (8) { EmptySquare.new } }
    setup
    @captured_pieces = []
  end


  def move(start, end_pos)
      raise BadMoveError.new unless self[start].valid_moves.include?(end_pos)

      if !self[end_pos].is_a?(EmptySquare)
        @captured_pieces << self[end_pos]
      end

      self[end_pos] = self[start]
      self[start] = EmptySquare.new
      self[end_pos].pos = end_pos
      self[end_pos].first_move = false #refactor - can do both of these lines in 1 method in Piece

      if king_castled(start, end_pos)
        king_info = king_castled(start, end_pos)
        move_rook_after_castle(king_info)
      end

      if pawn_promoted(end_pos)
        choose_pawn_promotion(end_pos)
      end

  end


  def setup


    grid[1].each_with_index do |piece, index|
      setup_piece(:black, [1,index], Pawn)
    end

    grid[6].each_with_index do |piece, index|
      setup_piece(:white, [6,index], Pawn)
    end


    setup_piece(:black, [0,0], Rook)
    setup_piece(:black, [0,7], Rook)
    setup_piece(:black, [0,1], Knight)
    setup_piece(:black, [0,6], Knight)
    setup_piece(:black, [0,2], Bishop)
    setup_piece(:black, [0,5], Bishop)
    setup_piece(:black, [0,3], Queen)
    setup_piece(:black, [0,4], King)

    setup_piece(:white, [7,0], Rook)
    setup_piece(:white, [7,7], Rook)
    setup_piece(:white, [7,1], Knight)
    setup_piece(:white, [7,6], Knight)
    setup_piece(:white, [7,2], Bishop)
    setup_piece(:white, [7,5], Bishop)
    setup_piece(:white, [7,3], Queen)
    setup_piece(:white, [7,4], King)


  end

  def setup_piece(color, pos, piece)
    self[pos] = piece.new(color, pos, self)
  end

  def in_check?(color)
    each_piece_with_pos do |piece, pos|
      return true if piece.moves.include?(find_king(color))
    end
    false
  end

  def checkmate?(color)
    each_piece_with_pos do |piece, pos|
      return false if piece.color == color && !piece.valid_moves.empty?
    end
    true
  end

  def find_king(color)
    each_piece_with_pos do |piece, pos|
      return pos if piece.is_a?(King) && piece.color == color
    end
  end

  def each_piece_with_pos(&prc)
    grid.each_with_index do |row, r|
      row.each_with_index do |el, c|
        prc.call(el, [r, c]) unless el.is_a?(EmptySquare)
      end
    end
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

class TestBoard < Board

  def initialize(board)
    @board = board
    @grid = Array.new(8) { Array.new (8) { EmptySquare.new } }
    setup
  end

  def setup
    @board.each_piece_with_pos do |piece, pos|
      setup_piece(piece.color, piece.pos, piece.class)
    end
  end

  def move(start, end_pos)
      raise BadMoveError.new unless self[start].moves.include?(end_pos)

      self[end_pos] = self[start]
      self[start] = EmptySquare.new
      self[end_pos].pos = end_pos
      self[end_pos].first_move = false #refactor - can do both of these lines in 1 method in Piece
  end

end

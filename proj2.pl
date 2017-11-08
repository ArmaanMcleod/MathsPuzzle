%  File                : proj2.pl
%  Student Number      : 837674
%  Author              : Armaan Dhaliwal-Mcleod
%  Purpose             : Solution to COMP30020 Project 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Description
%% The purpose of this project is to solve maths puzzles with the Prolog
%% programming language. A maths puzzle is a grid of squares, with each
%% square to be filled with a single digit 1-9 satisfying some constraints.
%% The constaints are:
%%      * Each row and each column contains no repeated digits
%%      * All squares on the diagonal line from upper left to lower right 
%%        contain the same value.
%%      * The heading of each row and column(leftmost square in a row and
%%        and topmost square in a column) holds either the product or the
%%        the sum of all the digits in that row or column
%%
%% The row and column headers are not considered to be apart of the row or
%% column, and can have a digit larger than a single digit. The upper left
%% corner of the puzzle is ignored. When a puzzle is originally posed, most
%% or all the squares will be empty, with the headings filled in. The goal
%% of this project is to fill in all the squares according to the constraints
%% above. It is assumed that a proper maths puzzle will have at most one
%% solution.

%% My Strategy
%% My solution to this problem is not complicated, and simply backtracks all
%% same solutions until it finds a solution. I first applied Hint 1, by
%% unifying the diagonals. This was done by skipping the first row of the 
%% puzzle, andaccumulating all the diagonal elements into one list. If the
%% list had identical elements, then the diagonals are valid. 
%% I then applied Hint 2, and checked checked that the rows and
%% columns are valid. This was done by first checking that each row was
%% either the sum or the product of the header, then transposing the puzzle
%% to do the same procedure on the columns. 
%% I then applied Hint 3 and backtracked all solutions, which is not very
%% efficient, but works fine for 2x2 and 3x3 puzzles. This basic 
%% approach unfortunately is slow for 4x4 puzzles. 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           The predicates defined below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% libraries loaded
:- ensure_loaded(library(clpfd)).

%% puzzle_solution(Puzzle)
% Generates a solution to a maths puzzle passed as a proper list
% First remove first row from puzzle
% Then check the diagonals are the same
% Then check if the row headings are valid with maplist/2
% Then use transpose/2 on the puzzle for the columns
% to become rows
% Check the columns are valid with maplist/2
puzzle_solution(Puzzle) :-
    Puzzle = [_|T],
    check_diagonal(T),
    maplist(is_valid_heading, T),
    transpose(Puzzle, [_|T2]),
    maplist(is_valid_heading, T2).

%% check_diagonal(Puzzle)
% Obtain the list of diagonal elements
% Check if they are all the same
check_diagonal(X) :-
    get_diagonal(X, 1, Y), 
    all_same(Y).

%% get_diagonal(List, index, List)
% Base case for when the lists become empty
% Get the ith element, starting at 1
% Increment the index for the next row
% append the element to the resulting list
% Recurse through the puzzle for the next row
get_diagonal([], _, []).
get_diagonal([X|Xs], I, Y) :-
    nth0(I, X, E),
    I1 is I + 1,
    append([E], R, Y),
    get_diagonal(Xs, I1, R).

%% is_valid_heading(List)
% First check the range of the heading elements, excluding the heading
% Check that no repeated elements occur with all_different/1
% Check if the heading elements are the sum or product of the heading
% heading elements can only the sum or the product of a heading, not both
is_valid_heading([X|Xs]) :-
    check_range(Xs),
    all_different(Xs),
    (
        sum_list(Xs, X)
    ;   
        check_product(Xs, X)
    ).

%% check_range(List)
% Ensure base case for empty lists
% Use between/3 to ensure element element is between Low and High
% Recurse through the rest of the elements
check_range([]).
check_range([X|Xs]) :-
   L is 1,
   H is 9,
   between(L, H, X),
   check_range(Xs).

%% product(Left, Right, Product)
% Calculates the product of 2 numbers
product(A, B, P) :- P is A * B.

%% check_product(List, Product)
% Calculates product of list using foldl/4
% Inspiration taken here:
% https://stackoverflow.com/questions/33645947/
% prolog-finding-the-product-of-a-list
% Code understood and written by me
check_product(Xs, P) :- foldl(product, Xs, 1, P).

%% all_same(List)
% Checks if all the elements in a list are the same
% First use base cases to check for empty of single
% element lists. 
% Then go through the list and check for identical
% elements through unification
all_same([]).   
all_same([_]).
all_same([X, X|T]) :- 
    all_same([X|T]).


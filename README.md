# MIPS Tree Representation Converter and Search

This MIPS assembly program provides functionality to convert between two different tree representations and perform search operations on them.

## Project Structure

The program consists of the following main components:

1. **Data Section**: Contains tree representations and helper strings
2. **Main Program**: Coordinates the operations
3. **Queue Operations**: For BFS traversal
4. **Conversion Functions**: Between representation formats
5. **Search Functions**: To find elements in the tree

## Data Structures

### Tree Representations

1. **repOne**: Array representation (BFS order)
   - Space allocated: 28 bytes (7 words)
   
2. **repTwo**: Array representation (DFS order)
   - Predefined values: 4, 9, 10, 15, 10, 2, 3

### Queue
- Used for BFS traversal during conversions
- Size: 16 bytes (4 words)

## Functions

### Queue Operations
- `enqueue`: Adds an element to the queue
- `dequeue`: Removes and returns an element from the queue

### Conversion Functions
1. `convertToRepOne`:
   - Converts repTwo (DFS) to repOne (BFS)
   - Uses queue-based BFS algorithm

2. `convertToRepTwo`:
   - Converts repOne (BFS) to repTwo (DFS)
   - Uses recursive DFS algorithm

### Search Functions
1. `searchRepOne`:
   - Searches for a value in repOne (BFS order)
   - Returns the level where found (0 if not found)

2. `searchRepTwo`:
   - Searches for a value in repTwo by:
     1. Converting to repOne
     2. Searching in repOne
   - Returns the level where found (0 if not found)

### Utility Functions
- `print`: Prints an array with comma separation

## Usage

1. The main program demonstrates searching in repTwo by:
   - Converting to repOne
   - Searching the target value
   - Printing the result (level where found)

2. Example workflow:
   - Initialize queue pointers and size
   - Call searchRepTwo with target value
   - Print result

## Registers Usage

- `$s0`: Queue start pointer
- `$s1`: Queue end pointer
- `$s2`: Queue size
- `$s3`: repTwo pointer (for conversion)
- `$s7`: Tree size (7 elements)
- `$a1`: Typically used for function arguments
- `$v1`: Typically used for return values

## Example

To search for a value (e.g., 15) in repTwo:
1. The program converts repTwo to repOne
2. Searches for the value in repOne
3. Returns the level where found

## Notes

- The current implementation has repTwo predefined with values
- repOne is dynamically filled during conversion
- Queue operations are used for BFS traversal
- Search returns 0 if element not found

## How to Run

1. Load the program in a MIPS simulator (e.g., Mars, QtSpim)
2. Assemble and run
3. The program will execute the search operation and print the result

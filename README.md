Pipe Puzzle Game
© Eric Ernschwender, John Saba

First Implementation

-----------------------------------------

pipe game tiled aid:

file types:
.tmx -> tiled map file
.tsx -> tileset file (exported)

conventions:
- each pipe color or style of identical functionality should have 3 files with identical names, e.g. pipeTilesetBase1.tmx == pipeTilesetBase1.tsx == pipeTilesetBase1.png

to make changes to tileset:
- always start from pipeTitleSetBase1.tmx
- select "import tileset"
- make changes, save
- select "export tileset"
- for each additional color, copy pipeTileSetBase1.tsx (not .tmx) and give it a unique number, e.g. pipeTileSetBase2.tsx
- for each unique .tsx, open with a text editor and replace all instances of pipeTileSetBase1 with pipeTileSetBase[unique number here]
- the unique number should correspond to the name of the image file

-----------------------------------------



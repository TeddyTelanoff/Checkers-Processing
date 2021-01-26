int SPACE_WIDTH, SPACE_HEIGHT;

int[] sSpaces;
boolean sSelected, sTurn, sMoved, sGameOver;
int sSelectedSpaceX, sSelectedSpaceY;

boolean mouseInBounds() {
  return mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height;
}

void setup() {
  size(800, 800);
  SPACE_WIDTH = width / 8;
  SPACE_HEIGHT = height / 8;

  sSpaces = new int[8 * 8];
  sTurn = true;

  setupBoard();
}

void setupBoard() {
  for (int y = 0, black = 0; y < 3; y++, black++) {
    for (int x = 0; x < 8; x++) {
      int i = x + y * 8;
      if ((++black % 2) == 0)
        sSpaces[i] = 1;
    }
  }

  for (int y = 5, black = 0; y < 8; y++, black++) {
    for (int x = 0; x < 8; x++) {
      int i = x + y * 8;
      if ((black++ % 2) == 0)
        sSpaces[i] = 2;
    }
  }
}

void draw() {
  background(64);

  drawBoard();

  if (sGameOver)
  {
    textAlign(CENTER, CENTER);
    textSize(64);
    fill(55);
    text((sTurn ? "Black" : "White") + "  Wins!", width / 2, height / 2);

    fill(200);
    text((sTurn ? "Black" : "White") + "  Wins!", width / 2 - 5, height / 2 - 5);
    return;
  }

  if (!sSelected && mouseInBounds()) {
    sSelectedSpaceX = mouseX / SPACE_WIDTH;
    sSelectedSpaceY = mouseY / SPACE_HEIGHT;
    int i = sSelectedSpaceX + sSelectedSpaceY * 8;
    boolean selected = sSpaces[i] != 0;
    if (selected)
      drawMovableSpaces();

    noStroke();
    fill(0x2200E8CB);
    ellipse(sSelectedSpaceX * SPACE_WIDTH + SPACE_WIDTH / 2, sSelectedSpaceY * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .75, SPACE_HEIGHT * .75);
  } else {
    drawMovableSpaces();

    noStroke();
    fill(0x2200E8CB);
    ellipse(sSelectedSpaceX * SPACE_WIDTH + SPACE_WIDTH / 2, sSelectedSpaceY * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .75, SPACE_HEIGHT * .75);
  }
}

void drawBoard() {
  for (int y = 0, black = 0; y < 8; y++, black++)
    for (int x = 0; x < 8; x++) {
      // Background
      fill((++black % 2) * 255);
      rect(x * SPACE_WIDTH, y * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);

      // Piece
      int i = x + y * 8;
      switch (sSpaces[i]) {
      case 0: 
        break;
      case 1:
        stroke(46);
        fill(200);
        ellipse(x * SPACE_WIDTH + SPACE_WIDTH / 2, y * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .75, SPACE_HEIGHT * .75);
        break;
      case 3:
        stroke(46);
        fill(200);
        ellipse(x * SPACE_WIDTH + SPACE_WIDTH / 2, y * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .75, SPACE_HEIGHT * .75);

        fill(#FFE51F);
        rectMode(CENTER);
        rect(x * SPACE_WIDTH + SPACE_WIDTH / 2, y * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .25, SPACE_HEIGHT * .25);
        rectMode(CORNER);
        break;
      case 2:
        stroke(100);
        fill(100, 55, 55);
        ellipse(x * SPACE_WIDTH + SPACE_WIDTH / 2, y * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .75, SPACE_HEIGHT * .75);
        break;
      case 4:
        stroke(100);
        fill(75, 55, 55);
        ellipse(x * SPACE_WIDTH + SPACE_WIDTH / 2, y * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .75, SPACE_HEIGHT * .75);

        fill(#FFE51F);
        rectMode(CENTER);
        rect(x * SPACE_WIDTH + SPACE_WIDTH / 2, y * SPACE_HEIGHT + SPACE_HEIGHT / 2, SPACE_WIDTH * .25, SPACE_HEIGHT * .25);
        rectMode(CORNER);
        break;
      }
    }
}

void drawMovableSpaces() {
  boolean[] movableSpaces = getMovableSpaces(sSelectedSpaceX, sSelectedSpaceY);

  if (sSelected)
    fill(0xCC00E8CB);
  else
    fill(0x550087D8);

  if (movableSpaces[0]) // Top Left [0]
    rect((sSelectedSpaceX - 1) * SPACE_WIDTH, (sSelectedSpaceY - 1) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
  if (movableSpaces[1]) // Top Right [1]
    rect((sSelectedSpaceX + 1) * SPACE_WIDTH, (sSelectedSpaceY - 1) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
  if (movableSpaces[2]) // Bottom Left [2]
    rect((sSelectedSpaceX - 1) * SPACE_WIDTH, (sSelectedSpaceY + 1) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
  if (movableSpaces[3]) // Bottom Right [3]
    rect((sSelectedSpaceX + 1) * SPACE_WIDTH, (sSelectedSpaceY + 1) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);

  if (movableSpaces[4]) // Top Left Eat [4]
    rect((sSelectedSpaceX - 2) * SPACE_WIDTH, (sSelectedSpaceY - 2) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
  if (movableSpaces[5]) // Top Right Eat [5]
    rect((sSelectedSpaceX + 2) * SPACE_WIDTH, (sSelectedSpaceY - 2) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
  if (movableSpaces[6]) // Bottom Left Eat [6]
    rect((sSelectedSpaceX - 2) * SPACE_WIDTH, (sSelectedSpaceY + 2) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
  if (movableSpaces[7]) // Bottom Right Eat [7]
    rect((sSelectedSpaceX + 2) * SPACE_WIDTH, (sSelectedSpaceY + 2) * SPACE_HEIGHT, SPACE_WIDTH, SPACE_HEIGHT);
}

void mouseReleased() {
  if (sGameOver || !mouseInBounds())
    return;
  int x = mouseX / SPACE_WIDTH;
  int y = mouseY / SPACE_HEIGHT;
  int selPiece = sSpaces[sSelectedSpaceX + sSelectedSpaceY * 8];

  if (sSelected && sameTeam(int(sTurn) + 1, selPiece) && sSpaces[x + y * 8] == 0) {
    sMoved = false;

    if (x == sSelectedSpaceX - 1 || x == sSelectedSpaceX + 1)
      if ((y == sSelectedSpaceY - 1 && (selPiece != 1)) || (y == sSelectedSpaceY + 1 && selPiece != 2))

        if (abs(sSelectedSpaceX - x) == abs(sSelectedSpaceY - y))

          if (sSpaces[x + y * 8] == 0)
            movePiece(sSelectedSpaceX, sSelectedSpaceY, x, y);

    // Eating
    boolean[] movableSpaces = getMovableSpaces(sSelectedSpaceX, sSelectedSpaceY);
    
    if (movableSpaces[4] && canEat(selPiece, sSpaces[x + 1 + y * 8 + 8])) {
      movePiece(sSelectedSpaceX, sSelectedSpaceY, x, y);
      sSpaces[x + 1 + y * 8 + 8] = 0;
    } else if (movableSpaces[5] && canEat(selPiece, sSpaces[x - 1 + y * 8 + 8])) {
      movePiece(sSelectedSpaceX, sSelectedSpaceY, x, y);
      sSpaces[x - 1 + y * 8 + 8] = 0;
    } else if (movableSpaces[6] && canEat(selPiece, sSpaces[x + 1 + y * 8 - 8])) {
      movePiece(sSelectedSpaceX, sSelectedSpaceY, x, y);
      sSpaces[x + 1 + y * 8 - 8] = 0;
    } else if (movableSpaces[7] && canEat(selPiece, sSpaces[x - 1 + y * 8 - 8])) {
      movePiece(sSelectedSpaceX, sSelectedSpaceY, x, y);
      sSpaces[x - 1 + y * 8 - 8] = 0;
    }

    if (sMoved) {
      checkIfKings();
      sTurn = !sTurn;

      checkWin();
    }
  }

  if (!sSelected && sameTeam(int(sTurn) + 1, selPiece) && sSpaces[x + y * 8] != 0)
    sSelected = true;
  else if (sSelected)
    sSelected = false;
}

void checkIfKings() {
  for (int x = 0; x < 8; x++)
    if (sSpaces[x] == 2)
      sSpaces[x] = 4;
    else if (sSpaces[x + 7 * 8] == 1)
      sSpaces[x + 7 * 8] = 3;
}

void movePiece(int xFrom, int yFrom, int xTo, int yTo) {
  assert sSpaces[xFrom + yFrom * 8] != 0;
  assert sSpaces[xTo + yTo * 8] == 0;

  sSpaces[xTo + yTo * 8] = sSpaces[xFrom + yFrom * 8]; 
  sSpaces[xFrom + yFrom * 8] = 0;

  sMoved = true;
}

void checkWin() {
  boolean hasWhite = false, hasBlack = false;
  for (int i = 0; i < 8 * 8; i++)
    if (sameTeam(1, sSpaces[i]))
      hasWhite = true;
    else if (sameTeam(2, sSpaces[i]))
      hasBlack = true;

  if (!hasWhite)
    sTurn = sGameOver = true;

  if (!hasBlack)
    sTurn = !(sGameOver = true);
}

boolean sameTeam(int x, int y) {
  if (x == 0 || y == 0)
    return x == y;

  return (x % 2) == (y % 2);
}

boolean canEat(int eater, int food) {
  if (food == 0)
    return false;

  return (eater % 2) != (food % 2);
}

boolean[] getMovableSpaces(int x, int y) {
  boolean[] movableSpaces = new boolean[8];
  int i = x + y * 8, _x, _y;
  int selPiece = sSpaces[i];

  if (!sameTeam(int(sTurn) + 1, selPiece))
    return movableSpaces;

  if (selPiece != 1) {
    // Top Left [0]
    _x = x - 1;
    _y = y - 1;

    if (_x >= 0 && _y >= 0) {
      i = _x + _y * 8;
      movableSpaces[0] = sSpaces[i] == 0;
    }

    // Top Right [1]
    _x = x + 1;
    _y = y - 1;

    if (_x < 8 && _y >= 0) {
      i = _x + _y * 8;
      movableSpaces[1] = sSpaces[i] == 0;
    }

    // Top Left Eat [4]
    _x = x - 2;
    _y = y - 2;

    if (!movableSpaces[0] && _x >= 0 && _y >= 0 && canEat(selPiece, sSpaces[x - 1 + y * 8 - 8])) {
      i = _x + _y * 8;
      movableSpaces[4] = sSpaces[i] == 0;
    }

    // Top Right Eat [5]
    _x = x + 2;
    _y = y - 2;

    if (!movableSpaces[1] && _x < 8 && _y >= 0 && canEat(selPiece, sSpaces[x + 1 + y * 8 - 8])) {
      i = _x + _y * 8;
      movableSpaces[5] = sSpaces[i] == 0;
    }
  }

  if (selPiece != 2) {
    // Bottom Left [2]
    _x = x - 1;
    _y = y + 1;

    if (_x >= 0 && _y < 8) {
      i = _x + _y * 8;
      movableSpaces[2] = sSpaces[i] == 0;
    }

    // Bottom Right [3]
    _x = x + 1;
    _y = y + 1;

    if (_x < 8 && _y < 8) {
      i = _x + _y * 8;
      movableSpaces[3] = sSpaces[i] == 0;
    }

    // Bottom Left Eat [6]
    _x = x - 2;
    _y = y + 2;

    if (!movableSpaces[2] && _x >= 0 && _y < 8 && canEat(selPiece, sSpaces[x - 1 + y * 8 + 8])) {
      i = _x + _y * 8;
      movableSpaces[6] = sSpaces[i] == 0;
    }

    // Bottom Right Eat [7]
    _x = x + 2;
    _y = y + 2;

    if (!movableSpaces[3] && _x < 8 && _y < 8 && canEat(selPiece, sSpaces[x + 1 + y * 8 + 8])) {
      i = _x + _y * 8;
      movableSpaces[7] = sSpaces[i] == 0;
    }
  }

  return movableSpaces;
}

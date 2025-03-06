// This is an array to store all the flag images
PImage[] flags = new PImage[16];

// These are the names of the countries
String[] countries = {
  "Russia", "Saudi Arabia", "Egypt", "Uruguay", 
  "Portugal", "Spain", "Morocco", "Iran", 
  "France", "Australia", "Peru", "Denmark", 
  "Argentina", "Iceland", "Croatia", "Nigeria"
};

// These are the file names of the flag images
String[] fileNames = {
  "Russia Flag.png", "Saudi Arabia Flag.png", "Egypt Flag.png", "Uruguay Flag.png",
  "Portugal Flag.png", "Spain Flag.png", "Morocco Flag.png", "Iran Flag.png",
  "France Flag.png", "Australia Flag.png", "Peru Flag.png", "Denmark Flag.png",
  "Argentina Flag.png", "Iceland Flag.png", "Croatia Flag.png", "Nigeria Flag.png"
};

// This is the index of the current flag being shown
int currentFlagIndex;

// This is the player's score
int score = 0;

// This is the number of lives the player has
int lives = 3;

// This is to check if the game is over
boolean gameOver = false;

// This is to check if the player is dragging the flag
boolean dragging = false;

// These are the x and y positions of the flag
int flagX, flagY;

void setup() {
  // Set the size of the window
  size(1000, 500);

  // Set the background color to dark blue
  background(30, 50, 90);

  // Center the text
  textAlign(CENTER, CENTER);

  // Load all the flag images
  for (int i = 0; i < flags.length; i++) {
    flags[i] = loadImage("flags/" + fileNames[i]);
    if (flags[i] == null) {
      println("Error: Could not load image for " + countries[i]);
    }
  }

  // Pick a random flag to start the game
  currentFlagIndex = (int)random(flags.length);

  // Set the initial position of the flag
  flagX = width/2 - 50;
  flagY = height - 100;
}

void draw() {
  // Clear the screen with dark blue
  background(30, 50, 90);

  // If the game is over, show the game over screen
  if (gameOver) {
    showGameOver();
    return;
  }

  // Draw the groups and flags
  drawGroups();

  // Draw the current flag
  if (dragging) {
    image(flags[currentFlagIndex], mouseX - 25, mouseY - 12, 50, 25);
  } else {
    image(flags[currentFlagIndex], flagX, flagY, 50, 25);
  }

  // Draw the score and lives
  drawScore();
}

void drawGroups() {
  // Draw a line in the middle of the screen
  stroke(255);
  strokeWeight(3);
  line(490, 0, 490, 500);

  // Draw Group A
  drawGroup(50, 30, "GROUP A", new String[]{"RUSSIA", "SAUDI ARABIA", "EGYPT", "URUGUAY"}, color(170, 210, 230));

  // Draw Group B
  drawGroup(50, 200, "GROUP B", new String[]{"PORTUGAL", "SPAIN", "MOROCCO", "IRAN"}, color(255, 255, 100));

  // Draw Group C
  drawGroup(500, 30, "GROUP C", new String[]{"FRANCE", "AUSTRALIA", "PERU", "DENMARK"}, color(170, 210, 230));

  // Draw Group D
  drawGroup(500, 200, "GROUP D", new String[]{"ARGENTINA", "ICELAND", "CROATIA", "NIGERIA"}, color(255, 255, 100));
}

void drawGroup(int x, int y, String groupName, String[] countries, int groupColor) {
  // Draw the group name
  fill(groupColor);
  textSize(20);
  text(groupName, x + 215, y - 20);

  // Draw the boxes and country names
  for (int i = 0; i < countries.length; i++) {
    fill(255);
    noStroke();
    rect(x, y + i * 30, 430, 25);

    // Draw the flag
    int index = getCountryIndex(countries[i]);
    if (index != -1 && flags[index] != null) {
      image(flags[index], x, y + i * 30, 50, 25);
    }

    // Draw the country name
    fill(0);
    textSize(12);
    textAlign(LEFT, CENTER);
    text(countries[i], x + 60, y + i * 30 + 12);
  }
}

void drawScore() {
  // Draw the score
  fill(255);
  textSize(20);
  text("Score: " + score, 100, 30);

  // Draw the lives
  text("Lives: " + lives, width - 100, 30);
}

int getCountryIndex(String country) {
  // Find the index of the country in the array
  for (int i = 0; i < countries.length; i++) {
    if (countries[i].equalsIgnoreCase(country)) {
      return i;
    }
  }
  return -1;
}

void mousePressed() {
  // Check if the player clicked on the flag
  if (mouseX > flagX && mouseX < flagX + 50 && mouseY > flagY && mouseY < flagY + 25) {
    dragging = true;
  }
}

void mouseReleased() {
  if (gameOver || !dragging) return;

  dragging = false;

  // Check if the flag was dropped into the correct group
  String correctGroup = getGroupForCountry(countries[currentFlagIndex]);
  if (correctGroup != null) {
    if (isFlagInGroup(mouseX, mouseY, correctGroup)) {
      score++;
    } else {
      lives--;
    }

    if (lives <= 0) {
      gameOver = true;
    } else {
      currentFlagIndex = (int)random(flags.length);
      flagX = width/2 - 50;
      flagY = height - 100;
    }
  }
}

String getGroupForCountry(String country) {
  // Check which group the country belongs to
  if (country.equalsIgnoreCase("Russia") || country.equalsIgnoreCase("Saudi Arabia") || 
      country.equalsIgnoreCase("Egypt") || country.equalsIgnoreCase("Uruguay")) {
    return "GROUP A";
  } else if (country.equalsIgnoreCase("Portugal") || country.equalsIgnoreCase("Spain") || 
             country.equalsIgnoreCase("Morocco") || country.equalsIgnoreCase("Iran")) {
    return "GROUP B";
  } else if (country.equalsIgnoreCase("France") || country.equalsIgnoreCase("Australia") || 
             country.equalsIgnoreCase("Peru") || country.equalsIgnoreCase("Denmark")) {
    return "GROUP C";
  } else if (country.equalsIgnoreCase("Argentina") || country.equalsIgnoreCase("Iceland") || 
             country.equalsIgnoreCase("Croatia") || country.equalsIgnoreCase("Nigeria")) {
    return "GROUP D";
  }
  return null;
}

boolean isFlagInGroup(int x, int y, String group) {
  // Check if the flag is in the correct group area
  if (group.equals("GROUP A") && x > 50 && x < 480 && y > 30 && y < 150) {
    return true;
  } else if (group.equals("GROUP B") && x > 50 && x < 480 && y > 200 && y < 320) {
    return true;
  } else if (group.equals("GROUP C") && x > 500 && x < 930 && y > 30 && y < 150) {
    return true;
  } else if (group.equals("GROUP D") && x > 500 && x < 930 && y > 200 && y < 320) {
    return true;
  }
  return false;
}

void showGameOver() {
  // Show the game over screen
  fill(255);
  textSize(40);
  text("Game Over!", width/2, height/2 - 50);
  text("Final Score: " + score, width/2, height/2);
}

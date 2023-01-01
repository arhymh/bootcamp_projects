win <- 0
lose <- 0 
tie <- 0

##roundresult_logic
roundresult <- function(result)
if (pick != 0 & pick != 2 & pick != 5)
    {print("You didn't play by the rules, try again")
} else if (pick-bot == 0)
    {print("It’s a tie!")
     tie <<- tie +1
     print("Another round?")
} else if (pick-bot == 2 | pick-bot == 3 | pick-bot == -5)
    {print("You lose!")
     lose <<- lose +1 
     print("Another round?")
    
} else if (pick-bot == 5| pick-bot == -2| pick-bot == -3)
    {print("You won, so what?")
    win <<- win +1 
    print("Another round?")
}


##ask
ask <- function(name) {
 print("Fine. Enough is enough")
 print("Let’s see… Oh, What’s your name again?")
 name <- readLines (con="stdin",n=1)
 print(paste("Right,",name))
  }

##final_result
final <- function(final) {
  if (win>lose){
    print("Congrats! You WON!")
  } else if(win<lose){
    print("Congrats…to me because I WON :P")
  } else {print("The match was a draw")
  }
}


## GAME START ##
##intro
round <- -1
print("Hi, I'm Samantha. Let's play Rock-Paper-Scissors!")
print("[1] OK [2] Let's play something else")
ans1 <- readLines (con="stdin",n=1)
if (ans1 == 1) {
  print("Nice choice")
  round <- round +1
  } else { print("I'm sorry, but it's my rules here.")
        print("type [1] I'll play [2] I'll quit")
        ans2 <- readLines (con="stdin",n=1)
          if (ans2 == 1) { 
            print("Nice choice")
            round <- round +1
            }
            else {
            print("Bye,Stranger")}
  }

##gamerules
if (round == 0) {
print("The rules are simple. We will play in rounds")
print("For each round, type the number instead of presenting your hand with me")
print("[0] as a closed fist for ROCK")
print("[2] as a fist with 2 extended fingers for SCISSORS")
print("[5] as an open-palm for PAPER")
#print("[x] If you want to stop playing")
print("Start typing when you are ready")
}


##round 
while (round >= 0) 
{ 
  bot <- sample(c(0,2,5),1)
  bot <- as.numeric(bot)
  pick <- readLines (con="stdin",n=1)
  print(paste("You:",pick))
  if (pick != "x") {
    pick <- as.numeric(pick)
    print(paste("Me:",bot))
    roundresult()
    print("[0] Rock [2] Scissors [5] Paper [x] Stop playing")
    } else {
    result <- data.frame (win,lose,tie)
    ask()
    print(result)
    final()
    break
    }
}

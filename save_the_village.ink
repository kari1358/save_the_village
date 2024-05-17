VAR playerName = "Alex"
VAR playerCourage = 4
VAR playerEnergy = 4
VAR playerBag = 7
LIST weatherState = raining, sunny, cloudy
VAR trailEffort = 0
VAR trailDanger = 0

//OPENING
~ weatherState = cloudy
Wizard: Hi, {playerName}! It's finally {day_of_week()}, the day the mission needs to start. If you find the blue plant, you can save the whole village from the deadly disease.
+ I'm ready for the adventure!
    -> pick_direction
+ Why me?
    -> player_story

=== function day_of_week() ===
 ~ return "{~Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday}"
 
=== player_story ===
~ playerCourage = playerCourage -1
Wizard: Your scouting experience in the past few years is so valuable. Don't worry, the crystal ball said the blue plant should be somewhere within five hours of walking distance from us.
+ I'll do it for the village.
    -> pick_direction
+ But I am afraid of the flying creatures.
    -> courage_test

=== courage_test ===
~ playerCourage = playerCourage -1
Wizard: You were assigned by the village. You can start the journey now, or face a life sentence.
+ I'd rather live in the prison than die in the dark forest.
    Wizard: I am sad that you gave up this early. I thought the village could count on you.
    -> END
+ I'll do it for the village.
    -> pick_direction

///PICKING A DIRECTION
=== pick_direction ===
Wizard: We are in this together! I'll support you when I can. However, I am not able to make a decision for you. Now, let's pick which direction you want to go.
+ North
    Wizard: Are you sure? 
    ++ Yes 
       -> choose_North
    ++ No
    Wizard: Let's try again.
        -> pick_direction
+ South
    Wizard: Are you sure? 
    ++ Yes
        -> choose_South
    ++ No
    Wizard: Let's try again.
        -> pick_direction

= choose_North
~ trailEffort += RANDOM(1,2)
~ trailDanger += RANDOM(1,2)
-> beginning_of_the_trail

= choose_South
~ trailEffort += RANDOM(5,6)
~ trailDanger += RANDOM(5,6)
-> beginning_of_the_trail

->->

///THE ADVENTURE
=== beginning_of_the_trail ===
Wizard:-> tunnel_wizard_story ->
Wizard: Well, I can be a talker sometimes! Let's get going. The clock is ticking.
-> raining_scene
= raining_scene
~ weatherState = raining
(After an hour)
Wizard: It's raining heavily. I know you've brought a bag to carry the plants back. Is the bag waterproof?
    + Yes.
    + I'm not sure.
      ~ playerBag = playerBag - bag_damaged()
    - -> body_of_the_trail

=== tunnel_wizard_story 
{ shuffle stopping:
- <> I know 4 people who were assigned this mission. They made the same choice. I mean, I knew them. Yes, they were all killed in the mission. But I am the best wizard. With my support, you will make it!
- <> I had been to that area before. There used to be a lot of mushrooms. Yes, mushroom is my favorite food. I usually have it for breakfast or lunch. I even packed some for this trip as a snack. We can have it for dinner, too.
- <> Good choice. Good choice. I met a lover of mine there. You know the love of wizards can be very intense. We lit up the whole area for 365 days with our magic in our first year of dating. That was a good time.
}
->->

=== function bag_damaged()===
~return RANDOM(1, 4)
    
=== body_of_the_trail ===
(In the rain, you've identified a plant that looks like what you are searching for. You feel a strong push from your back while you bend down to reach for it. Within a fraction of a second, you grab a full hand of the plant.)
Wizard: Watch out!
~ playerEnergy = playerEnergy -2
...
Wizard: Can you hear me?
...
Wizard: {playerName}! {playerName}! 
(You see the world spinning for a second or two.) 
Wizard: You were attacked by a flying monster. You lost consciousness for a while. And I am sorry, the plant you grabbed is in teal, not the blue one we need. Why don't you rest for a couple of days before we start the search again? ->rest_days

= rest_days
~ weatherState = sunny
+ I'll rest for 2 days.
    ~ playerEnergy = playerEnergy +2
+ I'll rest for 3 days.
    ~ playerEnergy = playerEnergy +3
+ I'll rest for 4 days.
    ~ playerEnergy = playerEnergy +3
    ~ playerCourage = playerCourage -2
* How many days do you suggest?
    Wizard: I recommend three days. It's your call. Just tell me what your decision is. -> rest_days
- Wizard: Let me turn the clock to make time pass quickly.
...
OK! You've met your resting goal. Let's get going.
-> fight

=fight
(As you look up again, there is a flying {flyingcreature()} flying right across you. It's going for something shining. It's about to grab the blue plant you've been looking for.)
+ Flying things are hard to fight. Let me rest more and fight later.
    Wizard: How many days do you think you need to rest for?
    -> rest_days
+ Fight for it now!
    (A fierce battle) 
    -> results

= results
Wizard: {wizard_announcement()}
->END

=== function flyingcreature() ===
 ~ return "{~rabbit|cat|turtle|cow|zebra|bear}"

=== function wizard_announcement ===
~temp score= playerCourage + playerEnergy - trailEffort - trailDanger
I know you were trying your best! If I have to rate your performance during this battle, it's {score}.
{ 
- score > 1 && playerBag >4: 
 <> Congratulations! You've won the battle and filled your bag with the plant the village needs! The villagers will thank you for saving their lives and the lives of their offspring.
- score > 1 && playerBag <=4: 
<> Even though you've won the battle, you won't be able to bring back enough blue plants this time. Your bag is {bag_condition()}. We will need to repair the bag before we try again.
-else:
 <> I'm sorry. You are about to die soon. I hope you rest in peace. On behalf of the village, I thank you for your sacrifice.
}

=== function bag_condition ===
{
- playerBag >4:
intact
- else:
damaged
}

; Create templates
(deftemplate Recipe
   (slot name)
   (slot cuisine)
   (slot difficulty)
   (slot ingredients)
   (slot instructions)
)

(deftemplate User
   (slot name)
   (slot cuisine-preference)
   (slot difficulty-preference)
   (slot ingredient-preference)
   (slot location)
)

(deftemplate Restaurant
    (slot name)
    (slot cuisine)
    (slot location)
)

; Create Rules

(defrule GetUserPreferences
    (not (User (name ?name)))
    =>
    ; inputs for user
    (printout t "insert your name !")
    (bind ?name (read))
    (printout t "Welcome, " ?name ". Let's find you a recipe!" crlf)
    (printout t "What cuisine do you prefer? ")
    (bind ?cuisine-pref (read))
    (printout t "How difficult should the recipe be? (Easy, Intermediate, Difficult) ")
    (bind ?difficulty-pref (read))
    (printout t "Do you have any specific ingredient preferences? ")
    (bind ?ingredient-pref (read))
    (printout t "What city are you in right now?")
    (bind ?location (read))
    ; create new user fact
    (assert (User 
        (name ?name)
        (difficulty-preference ?difficulty-pref)
        (cuisine-preference ?cuisine-pref)
        (ingredient-preference ?ingredient-pref)
        (location ?location)
    ))
)

(defrule filterBasedOnDifficulty
    (User
        (name ?name)
        (difficulty-preference ?difficulty-pref)
        (cuisine-preference ?cuisine-pref)
    )
    (Recipe
        (name ?recipe)
        (difficulty ?difficulty)
    )
    (test (eq ?difficulty-pref ?difficulty))
    =>
    (printout t "Based on your difficulty preferences (" ?difficulty-pref "), we recommend:" crlf)
    (printout t "Recipe: " ?recipe crlf)
    (printout t "" crlf)
)

(defrule filterBasedOnLocation
    (User
        (name ?name)
        (location ?location)
    )
    (Restaurant
        (name ?restaurant)
        (cuisine ?cuisine)
        (location ?rest-location)
    )
    (test (str-compare ?location ?rest-location))
    =>
    (printout t "Based on your location (" ?location "), we recommend:" crlf)
    (printout t "Restaurant: " ?restaurant crlf)
    (printout t "Cuisine: " ?cuisine crlf)
    (printout t "" crlf)

)

(defrule filterBasedOnType
    (User
        (name ?name)
        (cuisine-preference ?cuisine-pref)
    )
    (Recipe
        (name ?recipe)
        (cuisine ?cuisine)
        (ingredients ?ingredients)
        (instructions ?instructions)
    )
    (test (eq ?cuisine-pref ?cuisine))
    =>
    (printout t "Based on your cuisine type preference (" ?cuisine-pref "), we recommend:" crlf)
    (printout t "Recipe: " ?recipe crlf)
    (printout t "Cuisine type: " ?cuisine crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Instructions: " ?instructions crlf)
    (printout t "" crlf)
)

(defrule RecommendRecipe
    (User 
        (name ?name)
        (cuisine-preference ?cuisine-pref)
        (difficulty-preference ?difficulty-pref)
        (ingredient-preference ?ingredient-pref)
    )
    (Recipe 
        (name ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
    )
    (test (eq ?cuisine ?cuisine-pref))
    (test (eq ?difficulty ?difficulty-pref))
    (test (str-compare ?ingredients ?ingredient-pref))
    =>
    (printout t "The best fit for your preferences is " ?recipe crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Enjoy your meal!" crlf)
    ;(retract (User (name ?name)))
    ;(retract (Recipe (name ?recipe)))
)

(defrule ExitRecommendation
   (User (name ?name))
   =>
   (printout t "Thank you for using the personalized recipe recommender, " ?name "!" crlf)
   ;(retract (User (name ?name)))
   ;(exit)
)

; set initial facts

(deffacts SampleRecipes
    (Recipe 
        (name "Spaghetti Carbonara") 
        (cuisine Italian) 
        (difficulty Easy)
        (ingredients "spaghetti, eggs, bacon, Parmesan cheese") 
        (instructions "1. Cook spaghetti. 2. Fry bacon. 3. Mix eggs and cheese. 4. Toss with pasta.")
    )

    (Recipe 
        (name "Chicken Tikka Masala") 
        (cuisine Indian) 
        (difficulty Intermediate)
        (ingredients "chicken, yogurt, tomato sauce, spices") 
        (instructions "1. Marinate chicken. 2. Cook chicken. 3. Simmer in sauce.")
    )

    (Recipe 
        (name "Caesar Salad") 
        (cuisine American) 
        (difficulty Easy)
        (ingredients "romaine lettuce, croutons, Caesar dressing") 
        (instructions "1. Toss lettuce with dressing. 2. Add croutons.")
    )

    (Restaurant
        (name "Pizza Hut")
        (cuisine "Italian")
        (location "Surabaya, Jakarta, Medan, Solo, Palembang")
    )

    (Restaurant
        (name "McDonalds")
        (cuisine "American")
        (location "Surabaya, Jember, Batam, Bintan, Solo, Makassar")
    )

    (Restaurant
        (name "Resto Indian")
        (cuisine "Indian")
        (location "Surabaya, Jakarta, Solo, Makassar, Banyuwangi")
    )
)

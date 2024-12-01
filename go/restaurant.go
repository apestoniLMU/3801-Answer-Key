package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

// Utility for sleeping the current routine for a random amount of time (between (seconds / 2) and (seconds) seconds)
//with a message.
func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

// An Order is placed by a customer, taken by a cook, and held by the waiter until finished. When the cook is finished,
// the meal is sent to the customer through the reply channel. Each order has a unique sequential id.
type Order struct {
	id         uint64
	customer   string
	reply      chan *Order
	preparedBy string
}
var nextId atomic.Uint64

// The waiter holds onto outstanding orders, represented by channels, until they can be given to an available cook
// (max 3).
var waiter = make(chan *Order, 3)

// A Cook takes the next outstanding order from the waiter, cooks it (10s), and returns it through the order's "reply"
// channel.
func Cook(name string) {
	log.Println(name, "starting work")
	for {
		order := <-waiter
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		// Complete the order by sending the finished order back.
		order.reply <- order
	}
}

// A Customer eats five meals and then goes home. Each time they enter the restaurant, they try to place an order with
// the waiter. If the waiter is busy (already holding their maximum number of orders), the customer will wait for a
// certain duration for the waiter to become available, before abandoning their order.
func Customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	ch := make(chan *Order)
	for mealsEaten := 0; mealsEaten < 5; {
		order := &Order {
			id: 		nextId.Add(1),
			customer: 	name,
			reply: 		ch,
		}
		log.Println(name, "placed order", order.id)

		select {
			// Try to send the order to the waiter.
			case waiter <- order:
				// Wait to receive the finished meal from the cook.
				meal := <-ch
				do(2, name, "eating cooked order", meal.id, "prepared by", meal.preparedBy)
				mealsEaten += 1
			// Abandon order if it can't be placed with the waiter in time.
			case <- time.After(7 * time.Second):
				do(5, name, "waiting too long, abandoning order", order.id)
		}
	}
	log.Println(name, "going home")
}

func main() {
	var wg sync.WaitGroup

	customers := [10] string {
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}

	for _, customer := range customers {
		wg.Add(1)
		go Customer(customer, &wg)
	}

	go Cook("Remy")
	go Cook("Colette")
	go Cook("Linguini")

	wg.Wait()

	log.Println("Restaurant closing")
}

package main

import (
	"log"
	"math/rand"
	"time"
	"sync"
	"sync/atomic"
)

func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

type Order struct{
	id int64
	customer string
	reply chan *Order
	preparedBy string

}
var nextId atomic.Int64

var waiter = make(chan *Order, 3)

func Cook(name string){
	log.Println(name, "starting work")
	for {
		order := <-waiter
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.reply <- order
	}
}

func Customer(name string, wg *sync.WaitGroup){
	defer wg.Done()
	ch := make(chan *Order)
	for mealsEaten := 0; mealsEaten < 5;{
		order := &Order{id: nextId.Add(1), customer: name, reply: ch}
		log.Println(name, "placed order", order.id)

		select{
		case waiter <- order:
			meal := <-ch
			do(2, name, "eating cooked order", meal.id, "prepared by", meal.preparedBy)
			mealsEaten += 1
		case <-time.After(7*time.Second):
			do(5, name, "waiting too long, abandoning order", order.id)
		}
	}
	log.Println(name, "going home")
}

func main(){
	var waitGroup sync.WaitGroup
	customers := []string{
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}
	for _, customer := range customers {
		waitGroup.Add(1)
		go Customer(customer, &waitGroup)
	}
	go Cook("Remy")
	go Cook("Colette")
	go Cook("Linguini")
	waitGroup.Wait()
	log.Println("Restaurant closing")
}


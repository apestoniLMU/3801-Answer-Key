import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}
// Write your first then lower case function here
export function firstThenLowerCase(sentence, predicate) {
  for(let i=0; i<sentence.length; i++) {
    if(predicate(sentence[i]?.toLowerCase())) {
      return sentence[i]?.toLowerCase()
    }
  } return undefined
}

// Write your powers generator here
export function* powersGenerator(pm) {
  let index = 0
  while((pm.ofBase**index)<=pm.upTo) {
    yield pm.ofBase**index++
  }
}
// Write your say function here
export function say(word) {
  let words = [];

  function chain(wrd) {
    if (wrd === undefined || wrd===null) {
      if(words.length==0) { return "" }
      return words.join(' ')+"";
    } else {
      words.push(wrd);
      return chain;
    }
  }

  if (word !== undefined) {
    words.push(word);
    return chain
  } else {
    return ""
  }
}
// Write your line count function here
export async function meaningfulLineCount(filePath) {
  let count = 0;
  const file = await open(filePath,'r')
  for await(const line of file.readLines()) {
    if(line!="" && line.trim()!="" && line.trim()[0]!="#") {
      count+=1
    }
  }
  return count;
}
// Write your Quaternion class here
export class Quaternion {
  a = 0
  b = 0
  c = 0
  c = 0
  constructor(a, i, j, k) {
    this.a = a;
    this.b = i;
    this.c = j;
    this.d = k;
    Object.freeze(this)
  }

  toString() {
    let str = [];
    let ret = ""
    
    if(!(String(this.a)==0 && (this.b != 0 || this.c != 0 || this.d != 0))) {
      str.push(String(this.a));
    }

    function formatString(int, str, list) {
      if(Math.sign(int)==0) {
        return null
      } else {
        if(Math.sign(int)==1) {
          if(int==1) {
            list.push((list.length>0) ? "+"+str : str)
          } else {
            list.push("+"+String(int)+str)
          }
        } else if(Math.sign(int)==-1) {
          if(int==-1) {
            list.push("-"+str)
          } else {
            list.push(String(int)+str)
          }
        } else {
          return null
        }
      }
    }
    
    formatString(this.b,"i",str)
    formatString(this.c,"j",str)
    formatString(this.d,"k",str)
    
    if(str.length==0) { return "0" }
    
    for(const word of str) {
      ret += word
    }
    return ret
  }


  plus(q2) {
    return new Quaternion(this.a+q2.a,this.b+q2.b,this.c+q2.c,this.d+q2.d)
  }

  times(q2) {
    return new Quaternion(
      (this.a*q2.a - this.b*q2.b - this.c*q2.c - this.d*q2.d),
      (this.a*q2.b + this.b*q2.a + this.c*q2.d - this.d*q2.c),
      (this.a*q2.c - this.b*q2.d + this.c*q2.a + this.d*q2.b),
      (this.a*q2.d + this.b*q2.c - this.c*q2.b + this.d*q2.a)
    );
  }
  
  get conjugate() {
    return new Quaternion(this.a,-1*this.b,-1*this.c,-1*this.d)
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d]
  }

  equals(q2) {
    return (this.a===q2.a && this.b===q2.b && this.c===q2.c && this.d===q2.d)
  }
}
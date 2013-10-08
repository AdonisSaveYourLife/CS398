#include <stdio.h>
#include <stdlib.h>



typedef struct node_s {
  int data;
  struct node_s * prev;
  struct node_s * next;
} node_t;

typedef struct list_s {
  node_t * head;
  node_t * tail;
} list_t;

// You are to write the next three functions in MIPS.

void insert_element_after(node_t * node, node_t * prev, list_t * mylist) {
  if (prev == NULL) {
    node->next = mylist->head;
	 node->prev = NULL;
    if (mylist->head != NULL) {
      mylist->head->prev = node;
    }
    mylist->head = node;
    if (mylist->tail == NULL) {
      mylist->tail = node;
    }
    return;
  }
  if (prev->next == NULL) {
    node->next = NULL;
    mylist->tail = node;
  } else {
    node->next = prev->next;
    node->next->prev = node;
  }
  prev->next = node;
  node->prev = prev;
}

void remove_element(node_t * node, list_t * mylist) {
  // we don't deallocate node
  if (mylist->head == mylist->tail) {
    mylist->head = mylist->tail = NULL;
  } else if (node->prev == NULL) {
    mylist->head = node->next;
    node->next->prev = NULL;
  } else if (node->next == NULL) {
    mylist->tail = node->prev;
    node->prev->next = NULL;
  } else {
    node->prev->next = node->next;
    node->next->prev = node->prev;
  }
  node->next = node->prev = NULL;
  return;
}

void sort_list(list_t * mylist) {
  if (mylist->head == mylist->tail) {
	 return;
  }
  node_t *smallest = mylist->head, *trav;
  for (trav = smallest->next ; trav != NULL ; trav = trav->next) {
	 if (trav->data < smallest->data) {
		smallest = trav;
	 }
  }
  remove_element(smallest, mylist);
  sort_list(mylist);
  insert_element_after(smallest, NULL, mylist);
}

// We provide the next handy function in MIPS.

void print_list( list_t * mylist ) {
  node_t * node = mylist->head;
  while ( ( node != NULL ) ) {
    printf("%d ", node->data );
    node = node->next;
  }
  printf("\n");
}

// You don't have to worry about these two functions.

node_t * generate_new_node( int x ) {
  node_t * retval = malloc( sizeof(node_t) );
  retval->data = x;
  retval->prev = NULL;
  retval->next = NULL;
  return retval;
}

void insert_at_front( int x, list_t * mylist ) {
  node_t * node = generate_new_node(x);
  insert_element_after( node, NULL, mylist );
}

// some testing code!

main() {
  list_t mylist;
  mylist.head = mylist.tail = NULL;
  node_t * old_node;
  node_t * rm_node;
  
  // list creation phase
  insert_at_front(8,  &mylist);
  rm_node = mylist.head;
  insert_at_front(5,  &mylist);
  insert_at_front(1,  &mylist);
  insert_at_front(12, &mylist);
  insert_at_front(3,  &mylist);
  insert_at_front(9,  &mylist);
  insert_at_front(7,  &mylist);
  print_list(&mylist);
  
  // list sort phase
  sort_list( &mylist);
  print_list(&mylist);

  // element removal phase
  remove_element( mylist.head, &mylist );
  remove_element( mylist.head, &mylist );
  remove_element( mylist.tail, &mylist );
  remove_element( rm_node, &mylist );
  print_list(&mylist);
}


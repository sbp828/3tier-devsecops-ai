import React, { createContext, useContext, useState } from "react";

const CartContext = createContext();

export function CartProvider({ children }) {
  const [cart, setCart] = useState([]);

  // ➕ ADD ITEM (MAX 5 RULE)
  const addToCart = (item) => {
    setCart((prev) => {
      const existing = prev.find((i) => i.name === item.name);

      if (existing) {
        return prev.map((i) =>
          i.name === item.name
            ? {
                ...i,
                quantity: i.quantity < 5 ? i.quantity + 1 : 5
              }
            : i
        );
      }

      return [...prev, { ...item, quantity: 1 }];
    });
  };

  // ➕ INCREASE
  const increaseQty = (name) => {
    setCart((prev) =>
      prev.map((i) =>
        i.name === name
          ? {
              ...i,
              quantity: i.quantity < 5 ? i.quantity + 1 : 5
            }
          : i
      )
    );
  };

  // ➖ DECREASE
  const decreaseQty = (name) => {
    setCart((prev) =>
      prev
        .map((i) =>
          i.name === name
            ? { ...i, quantity: i.quantity - 1 }
            : i
        )
        .filter((i) => i.quantity > 0)
    );
  };

  return (
    <CartContext.Provider
      value={{
        cart,
        addToCart,
        increaseQty,
        decreaseQty
      }}
    >
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  return useContext(CartContext);
}

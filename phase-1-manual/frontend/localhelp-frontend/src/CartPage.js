import React from "react";
import { useCart } from "./CartContext";
import { useNavigate } from "react-router-dom";
import "./App.css";

function CartPage() {
  const { cart, increaseQty, decreaseQty } = useCart();
  const navigate = useNavigate();

  const totalItems = cart.reduce((sum, i) => sum + i.quantity, 0);

  return (
    <div className="page">

      {/* TOP BAR */}
      <div className="help-topbar">
        <h2>Your Cart</h2>

        <button onClick={() => navigate("/help")}>
          ⬅ Back
        </button>
      </div>

      {/* EMPTY */}
      {cart.length === 0 ? (
        <div style={{ padding: "20px" }}>
          <h3>Cart is empty 🛒</h3>
        </div>
      ) : (
        <>
          <div className="medicine-grid">
            {cart.map((item) => (
              <div className="medicine-card" key={item.name}>
                <h3>{item.name}</h3>

                <div className="qty-controls">
                  <button onClick={() => decreaseQty(item.name)}>
                    ➖
                  </button>

                  <span>{item.quantity}</span>

                  <button
                    onClick={() => increaseQty(item.name)}
                    disabled={item.quantity >= 5}
                  >
                    ➕
                  </button>
                </div>
              </div>
            ))}
          </div>

          <div style={{ padding: "20px" }}>
            <h3>Total Items: {totalItems}</h3>

            <button
              style={{
                marginTop: "10px",
                padding: "10px 20px",
                background: "green",
                color: "white",
                border: "none",
                cursor: "pointer"
              }}
              onClick={() => alert("Proceed to backend checkout 🚀")}
            >
              Proceed to Buy
            </button>
          </div>
        </>
      )}
    </div>
  );
}

export default CartPage;

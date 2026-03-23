import React, { useState } from "react";
import { useCart } from "./CartContext";
import { useNavigate } from "react-router-dom";
import "./App.css";

function Help() {
  const { cart, addToCart, increaseQty, decreaseQty } = useCart();
  const navigate = useNavigate();

  const [selectedService, setSelectedService] = useState("Medicine");

  const services = ["Medicine", "Parcel", "Grocery", "Bike Ride", "Elder Assist"];

  const medicineList = [
    "Paracetamol",
    "Dolo 650",
    "Cetirizine",
    "Azithromycin",
    "Ibuprofen"
  ];

  const getQty = (name) => {
    const item = cart.find((i) => i.name === name);
    return item ? item.quantity : 0;
  };

  return (
    <div className="help-page">

      {/* TOP BAR */}
      <div className="help-topbar">

        <h2>Local Help Services</h2>

        <div className="top-actions">

          {/* CART */}
          <div className="cart" onClick={() => navigate("/cart")}>
            🛒 <span>{cart.reduce((sum, i) => sum + i.quantity, 0)}</span>
          </div>

          {/* BACK */}
          <button className="back-btn" onClick={() => navigate("/")}>
            ⬅ Back
          </button>

        </div>

      </div>

      {/* SERVICES */}
      <div className="services">
        {services.map((service) => (
          <button
            key={service}
            onClick={() => setSelectedService(service)}
            className={selectedService === service ? "active" : ""}
          >
            {service}
          </button>
        ))}
      </div>

      {/* MEDICINE SECTION */}
      {selectedService === "Medicine" && (
        <div className="medicine-section">

          <h3>💊 Medicines</h3>

          <div className="medicine-grid">
            {medicineList.map((med) => {
              const qty = getQty(med);

              return (
                <div className="medicine-card" key={med}>
                  <h3>{med}</h3>

                  {qty === 0 ? (
                    <button
                      className="add-btn"
                      onClick={() => addToCart({ name: med })}
                    >
                      Add to Cart
                    </button>
                  ) : (
                    <div className="qty-controls">
                      <button onClick={() => decreaseQty(med)}>➖</button>
                      <span>{qty}</span>
                      <button
                        onClick={() => increaseQty(med)}
                        disabled={qty >= 5}
                      >
                        ➕
                      </button>
                    </div>
                  )}

                  {qty >= 5 && (
                    <small className="limit-text">Max limit reached</small>
                  )}

                </div>
              );
            })}
          </div>

        </div>
      )}

    </div>
  );
}

export default Help;

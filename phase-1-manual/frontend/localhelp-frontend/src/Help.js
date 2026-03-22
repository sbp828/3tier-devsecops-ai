import React, { useState } from "react";
import { useCart } from "./CartContext";
import "./App.css";

function Help() {
  const { cart, addToCart } = useCart();
  const [selectedService, setSelectedService] = useState(null);

  const services = ["Medicine", "Parcel", "Grocery", "Bike Ride", "Elder Assist"];

  const medicineList = [
    "Paracetamol",
    "Dolo 650",
    "Cetirizine",
    "Azithromycin",
    "Ibuprofen"
  ];

  return (
    <div className="page">

      {/* TOP BAR */}
      <div className="help-topbar">
        <h2>Local Help Services</h2>

        <div className="cart">
          🛒 <span>{cart.length}</span>
        </div>
      </div>

      {/* SERVICE BUTTONS */}
      <div className="service-grid">
        {services.map((s, i) => (
          <button key={i} onClick={() => setSelectedService(s)}>
            {s}
          </button>
        ))}
      </div>

      {/* MEDICINE LIST */}
      {selectedService === "Medicine" && (
        <div className="items">

          <h3>Available Medicines</h3>

          {medicineList.map((m, i) => (
            <div className="item" key={i}>
              <span>{m}</span>
              <button onClick={() => addToCart(m)}>
                Add to Cart
              </button>
            </div>
          ))}

        </div>
      )}

      {/* OTHER SERVICES PLACEHOLDER */}
      {selectedService && selectedService !== "Medicine" && (
        <div className="items">
          <h3>{selectedService} Service Coming Soon</h3>
        </div>
      )}

    </div>
  );
}

export default Help;

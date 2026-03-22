import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import AuthModal from "./AuthModal";

function Home() {
  const navigate = useNavigate();
  const [authType, setAuthType] = useState(null);

  return (
    <div className="page">

      {/* TOP BAR */}
      <div className="topbar">
        <div className="logo">LocalHelp</div>

        <div className="auth-buttons">
          <button onClick={() => setAuthType("signin")}>Sign In</button>
          <button onClick={() => setAuthType("signup")}>Sign Up</button>
        </div>
      </div>

      {/* AUTH MODAL */}
      {authType && (
        <AuthModal type={authType} onClose={() => setAuthType(null)} />
      )}

      {/* HERO */}
      <div className="hero">
        <h1>Welcome to our community!!</h1>
        <p>Share, Help, Connect</p>

        <button className="glow-btn" onClick={() => navigate("/help")}>
          Need Local Help?
        </button>
      </div>

      {/* BLOG SECTION */}
      <div className="blog">

        <div className="card">
          <h3>Community Update</h3>
          <p>Helping each other builds a stronger society 💚</p>
        </div>

        <div className="card">
          <h3>Announcement</h3>
          <p>LocalHelp platform is now active!</p>
        </div>

        <div className="card">
          <h3>Safety Tip</h3>
          <p>Always verify users before accepting help requests.</p>
        </div>

      </div>

    </div>
  );
}

export default Home;

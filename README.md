# JaCaMo House Construction Coordination System

## Overview

This project implements a multi-agent system where autonomous agents representing construction companies compete to win building tasks through auctions and then coordinate their execution through a shared organizational structure. The system manages the allocation and execution of building tasks for house construction.

## System Architecture

The system consists of several key components:

Agent Entities: Independent agents representing construction companies. Each agent has its own bidding strategy and task execution capabilities. Agents communicate through message passing and interact with shared artifacts.

Auction Mechanism: A competitive bidding process where agents submit offers for construction tasks. An owner agent manages the auctions and awards tasks to the lowest bidders who meet minimum reputation requirements.

Coordination Layer: A centralized organizational structure defined through MOISE specifications that coordinates the execution of awarded tasks. Winners of auctions commit to specific roles within this organization.

Execution Environment: A simulated house visualization that displays the progress of construction tasks as they are completed by agents.

## System Flow

The system begins with an auction phase where an owner agent creates auction artifacts for each construction task. Agent companies announce their capabilities and participate in bidding. The owner agent evaluates bids and awards tasks based on price and reputation. Winning agents establish contracts with the organization and adopt corresponding roles. The organizational structure coordinates task execution through missions and goals. Agents execute assigned work, updating the house visualization.

## Agent Strategies

The system includes multiple agent implementations, each with different bidding strategies. Some agents have fixed pricing for specific tasks, while others use dynamic pricing strategies that adjust bids during the auction. Certain agents are capable of multiple tasks with capacity constraints, and some adjust their pricing based on reputation considerations.

## Task Management

The system handles eight construction tasks: site preparation, floors, walls, roof, windows and doors, plumbing, electrical systems, and painting. Each task is associated with specific roles that winners must adopt in the organizational structure.

## Organizational Structure

The system uses MOISE specifications to define roles, groups, and schemes. Agents adopt specific roles based on the tasks they win in the auction. These roles carry obligations to complete assigned missions within the organizational context. The organizational structure enables coordination of parallel task execution.

## Configuration

The system's behavior can be configured through belief definitions in agent files and preference specifications in the owner agent. The organizational structure and role definitions are specified in XML format using MOISE specifications. Reputation scores can be adjusted to influence task allocation priorities.

## Building and Running

The project uses JaCaMo, a framework that integrates Jason agents, CArtAgO artifacts, and MOISE organizations. Standard Gradle build and execution commands apply for building and running the system.

## Key Technologies

Jason: BDI agent programming language
CArtAgO: Artifact-based environments for agent interaction
MOISE: Organizational specifications for coordination

<img width="1290" height="925" alt="image" src="https://github.com/user-attachments/assets/7c13c003-6cad-44fc-8279-161c19cbdb35" />

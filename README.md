# UriPoint Server Example Documentation [docs.uripoint.com](http://docs.uripoint.com)


# UriPoint - Universal Network Endpoint Management

![UriPoint](uripoint-box.png)

UriPoint is a comprehensive Python library designed for unified network endpoint management across multiple protocols. It simplifies the creation, management, and monitoring of network endpoints through a single, cohesive interface.

+ [GitHub Project](https://github.com/uripoint/python)
+ [Python Library](https://pypi.org/project/uripoint/)
+ [Documentation](https://docs.uripoint.com)

## Key Features

- **Unified Management**: Handle multiple protocols through one interface
- **Simplified Configuration**: Easy setup through CLI or Python API
- **Protocol Agnostic**: Support for web, streaming, IoT, and messaging protocols
- **Production Ready**: Built-in monitoring, testing, and persistence

## Overview of UriPoint's Capabilities

```ascii
                  ┌─────────────────────────────┐
                  │      UriPoint Platform      │
                  └─────────────────────────────┘
                                │
        ┌──────────────┬────────┴───────┬────────────────┐
        ▼              ▼                ▼                ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   Protocol   │ │    System    │ │  Management  │ │  Integration │
│    Layer     │ │ Architecture │ │    Tools     │ │  Framework   │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
```


## Examples

Each protocol example would demonstrate the basic usage of that protocol with UriPoint, while the use case examples would show how to combine multiple protocols to build more complex applications. The testing examples would demonstrate how to use UriPoint's testing framework to ensure reliability and performance.


### Protocol Examples: 
Individual examples for each supported protocol
### Use Cases: 
Complete examples demonstrating real-world applications
### Testing: 
Examples showing how to use UriPoint's testing framework

```
examples/
├── server_example.py                  # Main example server
├── README.md                          # Examples documentation
├── protocol_examples/                 # Protocol-specific examples
│   ├── http_example.py                # HTTP/REST API examples
│   ├── streaming_example.py           # RTSP, HLS, and DASH streaming examples
│   ├── mqtt_iot_example.py            # IoT device communication examples
│   ├── redis_example.py               # Data store access examples
│   ├── smtp_example.py                # Email handling examples
│   ├── amqp_example.py                # Message queuing examples
│   ├── dns_example.py                 # Domain resolution examples
│   ├── websocket_example.py           # WebSocket examples
│   └── ftp_example.py                 # File transfer examples
├── use_cases/                         # Real-world use case examples
│   ├── iot_monitoring/                # IoT monitoring system example
│   │   ├── setup.py
│   │   └── README.md
│   ├── api_gateway/                   # API gateway example
│   │   ├── setup.py
│   │   └── README.md
│   ├── streaming_service/             # Streaming service example
│   │   ├── setup.py
│   │   └── README.md
│   └── message_queue/                 # Message queue system example
│       ├── setup.py
│       └── README.md
└── testing/                           # Testing examples
    ├── performance_test.py            # Performance testing examples
    ├── integration_test.py            # Integration testing examples
    ├── chaos_test.py                  # Chaos testing examples
    └── protocol_test.py               # Protocol-specific testing examples
```

## Installation & Setup

### Basic Installation
```bash
pip install uripoint
```

For development:
```bash
pip install -r requirements-dev.txt
```

### Configuration
UriPoint stores configuration in `~/.uripoint_config.yaml` by default, or in the directory specified by the `URIPOINT_CONFIG_DIR` environment variable.

## Usage Guide

### CLI Commands

```bash
# Create an endpoint
uripoint --uri http://localhost:8080/api/users --data '{"response": {"users": []}}' --method GET POST PUT DELETE

# List all configured endpoints
uripoint --list

# Serve all endpoints
uripoint --serve

# Test endpoints
uripoint --test

# Detach specific endpoints
uripoint --detach "http://localhost:9000/api/hello" "http://localhost:9001/metrics"
```

### Python API

```python
from uripoint import UriPointCLI

cli = UriPointCLI()
cli.create_endpoint(
    uri='http://localhost:8000/api/users',
    data={
        'response': {'users': []},
        'methods': ['GET', 'POST', 'PUT', 'DELETE']
    }
)
```

## Supported Protocols

### Communication Protocols
- **Web Protocols**: HTTP/HTTPS, WebSocket, GraphQL
- **Streaming**: RTSP, HLS, DASH
- **IoT**: MQTT, CoAP
- **Messaging**: AMQP, ZeroMQ
- **Storage**: Redis, MongoDB
- **Email**: SMTP, IMAP
- **File Transfer**: FTP, SFTP
- **Name Resolution**: DNS

## Example Server

The repository includes an example server in `examples/server_example.py` that demonstrates how to use UriPoint to create mock HTTP endpoints with configurable responses.

### Running the Example

1. Install UriPoint:
   ```bash
   pip install .
   ```

2. Navigate to the examples directory:
   ```bash
   cd examples
   ```

3. Run the server example script:
   ```bash
   python server_example.py
   ```

4. Start the UriPoint server:
   ```bash
   uripoint --serve
   ```

### Example Endpoints

The example creates the following endpoints:
- `http://localhost:8000/api/hello`: Returns a JSON response with a "message" key
- `http://localhost:8000/api/status`: Returns a JSON response with "status" and "version" keys
- `http://localhost:8001/metrics`: Returns a JSON response containing example metrics data

## Protocol Examples

See [examples/protocol_examples/](examples/protocol_examples/) for comprehensive examples:
- [streaming_example.py](examples/protocol_examples/streaming_example.py): RTSP, HLS, and DASH streaming
- [mqtt_iot_example.py](examples/protocol_examples/mqtt_iot_example.py): IoT device communication
- [redis_example.py](examples/protocol_examples/redis_example.py): Data store access
- [smtp_example.py](examples/protocol_examples/smtp_example.py): Email handling
- [amqp_example.py](examples/protocol_examples/amqp_example.py): Message queuing
- [dns_example.py](examples/protocol_examples/dns_example.py): Domain resolution

## Testing Framework

UriPoint includes a comprehensive testing framework that ensures reliability and performance across all components:

```ascii
┌────────────────────────┐  ┌─────────────────────────┐
│   Performance Tests    │  │   Integration Tests     │
├────────────────────────┤  ├─────────────────────────┤
│ - Endpoint Creation    │  │ - Component Interaction │
│ - Concurrent Access    │  │ - Multi-Protocol        │
│ - Memory Usage         │  │ - Process Management    │
│ - Protocol Handlers    │  │ - Error Propagation     │
└────────────────────────┘  └─────────────────────────┘

┌────────────────────────┐  ┌─────────────────────────┐
│     Chaos Tests        │  │    Protocol Tests       │
├────────────────────────┤  ├─────────────────────────┤
│ - Random Operations    │  │ - Protocol Validation   │
│ - Process Chaos        │  │ - Handler Behavior      │
│ - Network Simulation   │  │ - Configuration         │
│ - Data Input Chaos     │  │ - Error Handling        │
└────────────────────────┘  └─────────────────────────┘
```

### Running Tests

```bash
# Run all tests
pytest tests/

# Run specific test categories
pytest tests/test_protocols.py
pytest tests/test_performance.py
pytest tests/test_integration.py
pytest tests/test_chaos.py

# Run with coverage report
pytest --cov=uripoint tests/
```

## Target Audience

UriPoint is designed for:
- **Distributed Systems Developers**: Building microservices architectures, managing service discovery
- **DevOps Engineers**: Infrastructure automation, service deployment, monitoring setup
- **IoT Specialists**: Device management, sensor networks, data collection systems
- **Streaming Engineers**: Video streaming services, live broadcast systems, content delivery networks
- **Backend Developers**: API development, service integration, message queue implementation

## Architecture

### System Components
```ascii
┌───────────────────────────────────────────────────────┐
│                    UriPoint System                    │
├───────────────┬──────────────────┬────────────────────┤
│ Core Engine   │ Protocol Layer   │ Management Layer   │
├───────────────┼──────────────────┼────────────────────┤
│ - Config      │ - HTTP/HTTPS     │ - CLI Interface    │
│ - Persistence │ - MQTT           │ - API Interface    │
│ - Monitoring  │ - RTSP           │ - Web Dashboard    │
│ - Testing     │ - Redis          │ - Monitoring UI    │
└───────────────┴──────────────────┴────────────────────┘
```

### Component Interaction
1. **Core Engine**
   - Configuration management
   - State persistence
   - Event handling
   - Resource management

2. **Protocol Layer**
   - Protocol-specific handlers
   - Data transformation
   - Connection management
   - Error handling

3. **Management Layer**
   - User interfaces
   - Monitoring tools
   - Administration features
   - Reporting systems

## Protocol Examples

### HTTP/REST API

```python
# Python
from uripoint import UriPointCLI

cli = UriPointCLI()
cli.create_endpoint(
    uri='http://localhost:8000/api/users',
    data={
        'response': {'users': []},
        'methods': ['GET', 'POST', 'PUT', 'DELETE']
    }
)
```

```bash
# CLI & curl
# Create endpoint
uripoint --uri http://localhost:8000/api/users --data '{"response": {"users": []}}' --method GET POST PUT DELETE

# Test endpoint
curl -X GET http://localhost:8000/api/users
```

### MQTT IoT Device

```python
# Python
cli.create_endpoint(
    uri='mqtt://localhost:1883/sensors/temperature',
    data={
        'topic': 'sensors/temperature',
        'qos': 1,
        'device': {
            'type': 'temperature',
            'location': 'room1'
        }
    }
)
```

### RTSP Stream

```python
# Python
cli.create_endpoint(
    uri='rtsp://localhost:8554/camera1',
    data={
        'stream_url': 'rtsp://camera.example.com/stream1',
        'transport': 'tcp'
    }
)
```

## Advantages Over Point Solutions

UriPoint provides a comprehensive solution that goes beyond simple protocol handling, offering a complete platform for building, managing, and operating network communications:

1. **Simplified Management**
   - Single interface for all protocols
   - Centralized configuration
   - Unified monitoring

2. **Cost Efficiency**
   - Reduced training needs
   - Lower maintenance overhead
   - Simplified licensing

3. **Enhanced Security**
   - Consistent security policies
   - Unified authentication
   - Centralized monitoring

4. **Better Performance**
   - Optimized communication
   - Reduced overhead
   - Integrated caching

## Contributing

We welcome contributions! See our [Contributing Guide](CONTRIBUTING.md) for details on:
- Code style
- Pull request process
- Development setup
- Testing requirements

## Support

- **Support**: Community support via GitHub Issues
- **Documentation**: Full docs at [docs.uripoint.com](https://docs.uripoint.com)
- **Updates**: See [CHANGELOG.md](CHANGELOG.md)




This document describes the example server provided in the `examples/server_example.py` file. This example demonstrates how to use UriPoint to create mock HTTP endpoints with configurable responses.

## Setup

1.  **Install UriPoint:**

    ```bash
    pip install .
    ```

    Or, if you are developing, install the development dependencies:

    ```bash
    pip install -r requirements-dev.txt
    ```

2.  **Navigate** to the `examples` directory:

    ```bash
    cd examples
    ```

## Running the Example

1.  **Run** the `server_example.py` script:

    ```bash
    python server_example.py
    ```

    This script will create the example endpoints and print a message indicating that the server is ready to be started.

2.  **Start** the UriPoint server:

    ```bash
    uripoint --serve
    ```

    This command will start the UriPoint server and make the defined endpoints accessible.

## Endpoints

The example creates the following endpoints:

*   `http://localhost:8000/api/hello`: Returns a JSON response with a "message" key.
*   `http://localhost:8000/api/status`: Returns a JSON response with "status" and "version" keys.
*   `http://localhost:8001/metrics`: Returns a JSON response containing example metrics data.

These endpoints are defined within the `setup_test_endpoints` function in [server_example.py](examples/server_example.py).  The `UriPointCLI.create_endpoint` method is used to define each endpoint, specifying the URI and the data to be returned.

## Note

The `uripoint --serve` command must be run in order to start the server and make the endpoints accessible.  The configuration for these endpoints is stored in the `.uripoint` directory (or the directory specified by the `URIPOINT_CONFIG_DIR` environment variable).



## Examples Directory

The `examples` directory contains the following files:

*   `server_example.py`: Demonstrates how to create mock HTTP endpoints using UriPoint.
*   `client_example.py`: Provides an example of how to interact with the endpoints created by `server_example.py`.
*   `config_example.json`: Contains a sample configuration file for UriPoint.

Each file in the `examples` directory serves a specific purpose in demonstrating the capabilities of UriPoint. Below is a brief overview of each file:

### server_example.py

This script sets up several mock HTTP endpoints using UriPoint. It includes the `setup_test_endpoints` function, which defines the endpoints and their responses.

### client_example.py

This script demonstrates how to interact with the endpoints created by `server_example.py`. It includes examples of making HTTP requests to the endpoints and processing the responses.

### config_example.json

This file contains a sample configuration for UriPoint. It can be used as a reference for creating your own configuration files.

Feel free to explore these files to better understand how UriPoint can be used to create and interact with mock HTTP endpoints.
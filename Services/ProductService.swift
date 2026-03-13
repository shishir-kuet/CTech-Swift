//
//  ProductService.swift
//  CTechApp
//

import Foundation

enum ProductServiceError: Error {
    case fileNotFound
    case dataLoadingFailed
    case decodingFailed
}

class ProductService {

    func loadProducts() throws -> [Product] {
        // Embedded JSON — avoids bundle resource copy issues
        let json = """
        [
          {
            "id": 1,
            "name": "Arduino Uno R3",
            "description": "The classic Arduino microcontroller board based on ATmega328P. Perfect for beginners and prototyping.",
            "price": 650.0,
            "imageName": "arduino",
            "imageURL": null,
            "category": "Microcontrollers",
            "brand": "Arduino",
            "stock": 50,
            "specifications": {
              "Voltage": "5V",
              "Digital I/O Pins": "14",
              "Analog Input Pins": "6",
              "Flash Memory": "32 KB",
              "Clock Speed": "16 MHz"
            }
          },
          {
            "id": 2,
            "name": "Raspberry Pi 4 Model B",
            "description": "Powerful single-board computer with quad-core ARM Cortex-A72 processor and 4GB RAM.",
            "price": 22500.0,
            "imageName": "raspberrypi",
            "imageURL": null,
            "category": "Microcontrollers",
            "brand": "Raspberry Pi Foundation",
            "stock": 20,
            "specifications": {
              "RAM": "4GB LPDDR4",
              "USB Ports": "4 (2x USB 3.0, 2x USB 2.0)",
              "HDMI": "2x Micro HDMI",
              "Processor": "ARM Cortex-A72 Quad-core 1.8GHz",
              "Connectivity": "Wi-Fi, Bluetooth 5.0"
            }
          },
          {
            "id": 3,
            "name": "ESP32 Development Board",
            "description": "Wi-Fi and Bluetooth enabled microcontroller, ideal for IoT projects.",
            "price": 850.0,
            "imageName": "esp32",
            "imageURL": null,
            "category": "Microcontrollers",
            "brand": "Espressif",
            "stock": 75,
            "specifications": {
              "Voltage": "3.3V",
              "Wi-Fi": "802.11 b/g/n",
              "Bluetooth": "BLE 4.2",
              "GPIO Pins": "34",
              "Flash Memory": "4 MB"
            }
          },
          {
            "id": 4,
            "name": "16x2 LCD Display Module",
            "description": "Standard 16 character by 2 row LCD display with I2C backpack for easy wiring.",
            "price": 320.0,
            "imageName": "lcd",
            "imageURL": null,
            "category": "Displays",
            "brand": "Generic",
            "stock": 100,
            "specifications": {
              "Interface": "I2C",
              "Characters": "16x2",
              "Backlight": "Blue/White",
              "Voltage": "5V"
            }
          },
          {
            "id": 5,
            "name": "HC-SR04 Ultrasonic Sensor",
            "description": "Ultrasonic distance measurement sensor with 2cm to 400cm range.",
            "price": 120.0,
            "imageName": "hcsr04",
            "imageURL": null,
            "category": "Sensors",
            "brand": "Generic",
            "stock": 200,
            "specifications": {
              "Range": "2cm - 400cm",
              "Frequency": "40 kHz",
              "Voltage": "5V",
              "Accuracy": "3mm"
            }
          },
          {
            "id": 6,
            "name": "Breadboard 830 Points",
            "description": "Full-size solderless breadboard with 830 tie-points for circuit prototyping.",
            "price": 180.0,
            "imageName": "breadboard",
            "imageURL": null,
            "category": "Components",
            "brand": "Generic",
            "stock": 150,
            "specifications": {
              "Tie Points": "830",
              "Size": "165mm x 54mm",
              "Voltage": "Up to 300V"
            }
          }
        ]
        """

        guard let data = json.data(using: .utf8) else {
            throw ProductServiceError.dataLoadingFailed
        }

        do {
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            throw ProductServiceError.decodingFailed
        }
    }

    func loadProductsAsync() async throws -> [Product] {
        return try loadProducts()
    }
}

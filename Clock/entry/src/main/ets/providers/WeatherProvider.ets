/**
 * 天气数据提供者
 * 负责获取和生成天气数据
 */
export interface WeatherData {
  city: string;
  temperature: number;
  weather: string;
  weatherCode: string;
  humidity: number;
  windSpeed: number;
  timestamp: number;
}

// 天气类型接口
export interface WeatherType {
  name: string;
  code: string;
  icon: string;
}

export class WeatherProvider {
  private cities: string[] = ['北京', '上海', '广州', '深圳', '成都', '杭州', '南京', '武汉', '西安', '重庆'];
  private weatherTypes: Map<string, WeatherType> = new Map([
    ['sunny', { name: '晴天', code: 'sunny', icon: '☀️' } as WeatherType],
    ['cloudy', { name: '多云', code: 'cloudy', icon: '☁️' } as WeatherType],
    ['rainy', { name: '雨天', code: 'rainy', icon: '🌧️' } as WeatherType],
    ['snowy', { name: '雪天', code: 'snowy', icon: '❄️' } as WeatherType],
    ['foggy', { name: '雾天', code: 'foggy', icon: '🌫️' } as WeatherType],
    ['windy', { name: '大风', code: 'windy', icon: '💨' } as WeatherType]
  ]);

  /**
   * 获取随机天气数据
   * @returns 随机生成的天气数据
   */
  getRandomWeather(): WeatherData {
    // 随机选择城市
    const cityIndex = Math.floor(Math.random() * this.cities.length);
    const city = this.cities[cityIndex];
    
    // 随机生成温度 (-10°C 到 40°C)
    const temperature = Math.floor(Math.random() * 50) - 10;
    
    // 随机选择天气类型
    const weatherKeys = Array.from(this.weatherTypes.keys());
    const weatherKey = weatherKeys[Math.floor(Math.random() * weatherKeys.length)];
    const weatherType = this.weatherTypes.get(weatherKey)!;
    const weather = weatherType.name;
    const weatherCode = weatherType.code;
    
    // 随机生成湿度 (30% - 90%)
    const humidity = Math.floor(Math.random() * 60) + 30;
    
    // 随机生成风速 (0 - 30 km/h)
    const windSpeed = Math.floor(Math.random() * 31);
    
    // 获取当前时间戳
    const timestamp = Date.now();
    
    return {
      city,
      temperature,
      weather,
      weatherCode,
      humidity,
      windSpeed,
      timestamp
    };
  }

  /**
   * 获取天气图标
   * @param weatherCode 天气代码
   * @returns 天气图标
   */
  getWeatherIcon(weatherCode: string): string {
    const weatherType = this.weatherTypes.get(weatherCode);
    return weatherType ? weatherType.icon : '🌤️';
  }

  /**
   * 获取城市列表
   * @returns 城市列表
   */
  getCities(): string[] {
    return [...this.cities];
  }

  /**
   * 根据城市获取天气
   * @param city 城市名称
   * @returns 指定城市的天气数据
   */
  getWeatherByCity(city: string): WeatherData {
    // 使用城市名称作为随机种子，确保同一城市在同一时间总是返回相同的天气
    const seed = city.charCodeAt(0) + Date.now();
    const random = (seed: number) => {
      const x = Math.sin(seed) * 10000;
      return x - Math.floor(x);
    };
    
    // 随机生成温度 (-10°C 到 40°C)
    const temperature = Math.floor(random(seed * 2) * 50) - 10;
    
    // 随机选择天气类型
    const weatherKeys = Array.from(this.weatherTypes.keys());
    const weatherKey = weatherKeys[Math.floor(random(seed * 3) * weatherKeys.length)];
    const weatherType = this.weatherTypes.get(weatherKey)!;
    const weather = weatherType.name;
    const weatherCode = weatherType.code;
    
    // 随机生成湿度 (30% - 90%)
    const humidity = Math.floor(random(seed * 5) * 60) + 30;
    
    // 随机生成风速 (0 - 30 km/h)
    const windSpeed = Math.floor(random(seed * 7) * 31);
    
    // 获取当前时间戳
    const timestamp = Date.now();
    
    return {
      city,
      temperature,
      weather,
      weatherCode,
      humidity,
      windSpeed,
      timestamp
    };
  }
}

// 导出单例实例
export const weatherProvider = new WeatherProvider();
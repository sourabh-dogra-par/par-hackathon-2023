using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Orders_Generator
{
    class Program
    {
        static void Main(string[] args)
        {
            Random locationRandom = new Random();

            Random orderSizeRandom = new Random();
            Random orderItemsRandom = new Random();
            Random pendingOrdersRandom = new Random();
            Random pendingOrdersSizeRandom = new Random();
            Random pendingOrderItemsRandom = new Random();
            Random bumpTimeRandom = new Random();

            List<string> ordersData = new List<string>();

            string orderData = string.Empty;

            orderData += "location" + ",";
            orderData += "year" + ",";
            orderData += "month" + ",";
            orderData += "day" + ",";
            orderData += "hour" + ",";
            orderData += "minute" + ",";
            orderData += "weeend" + ",";
            orderData += "orderSize" + ",";
            orderData += "orderItems" + ",";
            orderData += "pendingOrders" + ",";
            orderData += "pendingOrdersSize" + ",";
            orderData += "pendingOrderItems" + ",";
            orderData += "bumpTime";

            ordersData.Add(orderData);

            for (int i = 0; i < 100000; i++)
            {
                var location = locationRandom.Next(1, 4); // 3 Store
                var orderDate = GetRandomOrderDate();
                var orderSize = orderSizeRandom.Next(1, 51); // amount 50
                var orderItems = orderItemsRandom.Next(1, 6); // items 5
                var pendingOrders = pendingOrdersRandom.Next(1, 11); // 10 pending
                var pendingOrdersSize = pendingOrdersSizeRandom.Next(1, 251);
                var pendingOrderItems = pendingOrderItemsRandom.Next(1, 51);
                var bumpTime = bumpTimeRandom.Next(1, 31);

                orderData = string.Empty;

                orderData += location.ToString() + ",";
                orderData += orderDate.Year.ToString() + ",";
                orderData += orderDate.Month.ToString() + ",";
                orderData += orderDate.Day.ToString() + ",";
                orderData += orderDate.Hour.ToString() + ",";
                orderData += orderDate.Minute.ToString() + ",";
                orderData += orderDate.DayOfWeek == DayOfWeek.Saturday || orderDate.DayOfWeek == DayOfWeek.Sunday ? "1" + "," : "0" + ",";
                orderData += orderSize.ToString() + ",";
                orderData += orderItems.ToString() + ",";
                orderData += pendingOrders.ToString() + ",";
                orderData += pendingOrdersSize.ToString() + ",";
                orderData += pendingOrderItems.ToString() + ",";
                orderData += bumpTime.ToString();

                ordersData.Add(orderData);
            }

            string fileName = "orders_random_data.csv";
            if (File.Exists(fileName))
            {
                File.Delete(fileName);
            }

            using (StreamWriter writer = File.CreateText(fileName))
            {
                foreach (var order in ordersData)
                {
                    writer.WriteLine(order);
                }
            }

            Console.WriteLine("Done !!!");
            Console.ReadLine();
        }

        private static DateTime GetRandomOrderDate()
        {
            Random orderDateRandom = new Random();

            DateTime minDt = new DateTime(2020, 1, 1, 1, 0, 0);
            DateTime maxDt = DateTime.Now;

            int minutesDiff = Convert.ToInt32(maxDt.Subtract(minDt).TotalMinutes + 1);

            int r = orderDateRandom.Next(1, minutesDiff);
            return minDt.AddMinutes(r);
        }
    }
}

-- Importing libraries

import Control.Concurrent
import Text.Printf

-- Main function (call main on ghci to run the code)

main = do

    -- Defining amounts of each kind of soda (ml)

    amount_pepse_cola <- newMVar 2000
    amount_quate <- newMVar 2000
    amount_polo_norte <- newMVar 2000
    
    free <- newMVar True  -- Controls if the thread is free or busy (control variable)

    -- Calling threads alternately for each soda type

    -- Pepse Cola
    forkIO $ machineEmptying 1 "Pepse Cola" amount_pepse_cola free
    forkIO $ machineRefilling "Pepse Cola" amount_pepse_cola free
    -- Quate
    forkIO $ machineEmptying 2 "Guaraná Quate" amount_quate free
    forkIO $ machineRefilling "Guaraná Quate" amount_quate free
    -- Polo Norte
    forkIO $ machineEmptying 3 "Guaraná Polo Norte" amount_polo_norte free
    forkIO $ machineRefilling "Guaraná Polo Norte" amount_polo_norte free
    -- Pepse Cola
    forkIO $ machineEmptying 4 "Pepse Cola" amount_pepse_cola free
    forkIO $ machineRefilling "Pepse Cola" amount_pepse_cola free
    -- Quate
    forkIO $ machineEmptying 5 "Guaraná Quate" amount_quate free
    forkIO $ machineRefilling "Guaraná Quate" amount_quate free
    -- Polo Norte
    forkIO $ machineEmptying 6 "Guaraná Polo Norte" amount_polo_norte free
    forkIO $ machineRefilling "Guaraná Polo Norte" amount_polo_norte free
    -- Pepse Cola
    forkIO $ machineEmptying 7 "Pepse Cola" amount_pepse_cola free
    forkIO $ machineRefilling "Pepse Cola" amount_pepse_cola free
    -- Quate
    forkIO $ machineEmptying 8 "Guaraná Quate" amount_quate free
    forkIO $ machineRefilling "Guaraná Quate" amount_quate free
    -- Polo Norte
    forkIO $ machineEmptying 9 "Guaraná Polo Norte" amount_polo_norte free
    forkIO $ machineRefilling "Guaraná Polo Norte" amount_polo_norte free
    -- Pepse Cola
    forkIO $ machineEmptying 10 "Pepse Cola" amount_pepse_cola free
    forkIO $ machineRefilling "Pepse Cola" amount_pepse_cola free
    -- Quate
    forkIO $ machineEmptying 11 "Guaraná Quate" amount_quate free
    forkIO $ machineRefilling "Guaraná Quate" amount_quate free
    -- Polo Norte
    forkIO $ machineEmptying 12 "Guaraná Polo Norte" amount_polo_norte free
    forkIO $ machineRefilling "Guaraná Polo Norte" amount_polo_norte free


-- 2 situations: soda machine emptying & soda machine refilling -> 2 functions
-- Soda machine emptying:

machineEmptying :: Int -> String -> MVar Int -> MVar Bool -> IO ()
machineEmptying customer_number soda_name available_amount free

    = do 
        busy <- takeMVar free  -- Blocking the thread until the machine is available
        serving_soda <- takeMVar available_amount  -- Blocking the thread until confirmation that there's enough soda

        if serving_soda > 300 then
            do  
                threadDelay 1000000  -- In microsseconds (time to fullfill a soda cup)

                putMVar available_amount (serving_soda - 300)  -- Unblocking the thread and updating the available amount of soda
                printf "O cliente %d do refrigerante %s está enchendo seu copo!\n" customer_number soda_name

                -- Unblocking other variables
                putMVar free busy

                machineEmptying customer_number soda_name available_amount free  -- Calling the function again

            else 
                do
                    putMVar free busy  -- Making the machine available to use, since there aren't any customers


-- Soda machine refilling:

machineRefilling :: String -> MVar Int -> MVar Bool -> IO ()
machineRefilling soda_name available_amount free

    = do 
        busy <- takeMVar free  -- Blocking the thread until the machine is available
        current_soda <- takeMVar available_amount  -- Blocking the thread until we can access available_amount

        putStrLn (show current_soda)
        if current_soda < 1000 then
            do

                threadDelay 1500000  -- In microsseconds (time to refill the soda machine)
                putMVar available_amount (current_soda + 1000)  -- Updating soda amount

                current_soda <- takeMVar available_amount
                printf "O refrigerante %s foi reabastecido com 1000 ml, e agora possui %d ml!\n" soda_name current_soda

                putMVar available_amount current_soda
                putMVar free busy -- Making the machine available to use, since it is already refilled

            else
                do
                    putMVar available_amount current_soda
                    putMVar free busy  -- Making the machine available to use, since it doesn't need to be refilled
                    machineRefilling soda_name available_amount free
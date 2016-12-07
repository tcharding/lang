import System.IO

main :: IO ()
main = do
  inh <- openFile "in.txt" ReadMode
  foo <- hTell inh
  putStrLn $ "fooition: " ++ show foo
  foo <- hGetContents inh
  putStrLn foo
  

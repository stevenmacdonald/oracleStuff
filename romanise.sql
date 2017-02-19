create or replace function romanise(thisNumber pls_integer) return varchar2 is
  type validRomanNumerals_aat is table of varchar2(2) index by pls_integer;
  validRomanNumerals validRomanNumerals_aat;
  theResult  varchar2(20);
  remaining  pls_integer;
  toRomanise pls_integer;
  temp       pls_integer;
  idx        pls_integer;

  procedure romanise(remaining_in  in out pls_integer
                    ,numeralString in out varchar2) is
    iterations pls_integer;
    pos        pls_integer;
  begin
    iterations := remaining_in;
    
    while iterations > 0 loop
      if validRomanNumerals.exists(remaining_in) then
        pos := remaining_in;
      else
        pos := validRomanNumerals.prior(remaining_in);
      end if;
      numeralString := numeralString || validRomanNumerals(pos);
      iterations := iterations-pos;
    end loop;
  end romanise;

begin
  validRomanNumerals(1)    := 'I';
  validRomanNumerals(4)    := 'IV';
  validRomanNumerals(5)    := 'V';
  validRomanNumerals(9)    := 'IX';
  validRomanNumerals(10)   := 'X';
  validRomanNumerals(40)   := 'XL';
  validRomanNumerals(50)   := 'L';
  validRomanNumerals(90)   := 'XC';
  validRomanNumerals(100)  := 'C';
  validRomanNumerals(400)  := 'CD';
  validRomanNumerals(500)  := 'D';
  validRomanNumerals(900)  := 'CM';
  validRomanNumerals(1000) := 'M';

  -- add one to the number we intend to romanise to ensure we collect the right number to MOD buy later
  idx := validRomanNumerals.prior(thisNumber+1);
  remaining := thisNumber;
  while idx is not null loop
    -- split the number down into thousands, hundreds, tens etc on each iteration
    temp       := remaining;
    remaining  := MOD(remaining, idx); 
    toRomanise := temp-remaining;
    if toRomanise > 0 then
      romanise(toRomanise
              ,theResult);
    end if;
    idx := validRomanNumerals.prior(idx);
  end loop;
  return theResult;
end;
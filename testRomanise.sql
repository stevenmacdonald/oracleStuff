create or replace function testRomanise(convertThis in pls_integer 
                                       ,actualResult   in varchar2) return varchar2 is 
  expectedResult varchar2(20); 
begin 
  select trim(to_char(convertThis,'RN'))  
  into expectedResult 
  from dual; 

  return ('Test status:' || case when expectedResult != NVL(actualResult,'FAIL') then 
                                                    'FAIL' ||CHR(10)||
                                                    'Expected result: ' || expectedResult ||CHR(10)||
                                                    'Actual result: ' || actualResult
                                              else 'PASS'
                                         end);
  end if; 
end;

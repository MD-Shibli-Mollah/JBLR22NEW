*-----------------------------------------------------------------------------
* <Rating>249</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE CM.PRG.AMOUNT.TO.WORDS
*-----------------------------------------------------------------------------
* This is a main line routine to upload central bank codes data
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.BULK.CREDIT.AC
    $USING EB.DataAccess  
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.Foundation  	GOSUB INIT
    $USING EB.Interface   	GOSUB PROCESS
    $USING AC.AccountOpening	GOSUB WRITE.FILE
	RETURN
*-----
INIT:
*-----
   
	Y.OFS.SOURCE    = 'BULK.OFS'
	Y.APP.NAM.FT       = 'FUNDS.TRANSFER,'
		Y.APP.NAM.BULK   = 'FT.BULK.CREDIT.AC,TEST'
		Y.OFS.VERSION   = 'TEST'
    Y.FUNC          = 'I'
    Y.PROCESS       = 'PROCESS'
    Y.GTSMODE       = ''
    Y.NO.OF.AUTH    = 0
	  Y.TXN.ID        = ''
    ERR.OFS         = ''
    Y.INSERT.R.ADD  = 'ADD'
    Y.OFS.RECORD    = ''
    Y.TXN.VALUES    = ''
    
RETURN	

PROCESS:
*-------  
Y.DR.CCY = 'BDT'

    Y.OPTIONS<1>  = Y.OFS.SOURCE
    Y.OPTIONS<2>  = ''
    Y.OPTIONS<3>  = ''
    Y.OPTIONS<4>  = ''
  Y.OFS.TXN.CMT = '' ; Y.RES.OFS = ''
  OfsMessage<FT.TRANSACTION.TYPE> = 'AC'
  OfsMessage<FT.DEBIT.ACCT.NO> = 0101000005925
  OfsMessage<FT.DEBIT.CURRENCY> = Y.DR.CCY 
  OfsMessage<FT.DEBIT.AMOUNT> = 575
  OfsMessage<FT.CREDIT.ACCT.NO> = 0101000006018
  OfsMessage<FT.ORDERING.BANK> = 'JBL' 
  OfsMessage<FT.DR.ADVICE.REQD.Y.N> = 'N' 
  OfsMessage<FT.CR.ADVICE.REQD.Y.N> = 'N'
  DEBUG
  EB.Foundation.OfsBuildRecord('FUNDS.TRANSFER', 'I', 'PROCESS', 'FUNDS.TRANSFER,', '', 1, '', OfsMessage, Ofsrecord)
    EB.Interface.OfsGlobusManager('EBULK', Ofsrecord)
    T24TxnRef = FIELD(Ofsrecord, '/', 1);
    T24Status = FIELD(FIELD(Ofsrecord, '/', 3), ',', 1);
    OfsMessage = ''
    
  Y.ARRAY<-1> = T24TxnRef:",":T24Status   
DEBUG
    !R.REC.BULK = 'TRANSACTION.TYPE:1:1=AC,DR.ACCOUNT:1:1=0101000006018,DR.CURRENCY:1:1=BDT,DR.AMOUNT:1:1=575,CR.CURRENCY:1:1=BDT,CR.ACCOUNT:1:1=0101000005950,CR.AMOUNT:1:1=250,CR.ACCOUNT:2:1=0101000005968,CR.AMOUNT:2:1=37.5,CR.ACCOUNT:3:1=0101000005941,CR.AMOUNT:3:1=250,CR.ACCOUNT:4:1=0101000005933,CR.AMOUNT:4:1=37.5'
   OfsMessagebulk<FT.BKCRAC.TRANSACTION.TYPE> = 'AC'
   OfsMessagebulk<FT.BKCRAC.DR.CURRENCY> = 0101000006018
   OfsMessagebulk<FT.BKCRAC.DR.ACCOUNT> = Y.DR.CCY 
   OfsMessagebulk<FT.BKCRAC.DR.AMOUNT> = 575 
   OfsMessagebulk<FT.BKCRAC.CR.CURRENCY> = Y.DR.CCY
   OfsMessagebulk<FT.BKCRAC.CR.ACCOUNT,1> = 0101000005950
   OfsMessagebulk<FT.BKCRAC.CR.AMOUNT,1>  = 250
   OfsMessagebulk<FT.BKCRAC.CR.ACCOUNT,2>  = 0101000005968 
   OfsMessagebulk<FT.BKCRAC.CR.AMOUNT,2>  = 37.5
   OfsMessagebulk<FT.BKCRAC.CR.ACCOUNT,3>  = 0101000005941
   OfsMessagebulk<FT.BKCRAC.CR.AMOUNT,3>  = 250
   OfsMessagebulk<FT.BKCRAC.CR.ACCOUNT,4>  = 0101000005933
   OfsMessagebulk<FT.BKCRAC.CR.AMOUNT,4>  = 37.5
  EB.Foundation.OfsBuildRecord('FT.BULK.CREDIT.AC', 'I', 'PROCESS', 'FT.BULK.CREDIT.AC,TEST', '', 1, '', OfsMessagebulk, Ofsrecordbulk)
    EB.Interface.OfsGlobusManager('EBULK', Ofsrecordbulk)
    T24TxnRef = FIELD(Ofsrecordbulk, '/', 1);
    T24Status = FIELD(FIELD(Ofsrecordbulk, '/', 3), ',', 1);
    OfsMessage = ''
      Y.ARRAY<-1> = T24TxnRef:",":T24Status  
    RETURN
    
    
*=========
WRITE.FILE:
*=========
*-------------------------------
    Y.DIR = '/Temenos/T24/UD/JBL.BP'
    Y.FILENAME = "TEST.BULK.FT"
    OPEN Y.DIR TO C.OUT ELSE
        EXECUTE 'CREATE.FILE ':Y.DIR:' TYPE=UD'
        OPEN Y.DIR TO C.OUT ELSE
            CRT "OPENING OF ":Y.DIR:" FAILDED"
            RETURN
        END
    END
    IF NOT(Y.FILENAME) THEN
        CRT "No file name found to write data"
    END
    ELSE
    WRITE Y.ARRAY TO C.OUT,Y.FILENAME
        CRT "Please get your data in directory ":Y.DIR:" and file name :":Y.FILENAME
    END
*-------------------------------

    RETURN
END

* @ValidationCode : Mjo2OTY4MzM1ODQ6Q3AxMjUyOjE3MDUzODE0Mjk0NjM6bmF6aWhhcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2024 11:03:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

*-----------------------------------------------------------------------------
***Develop By: Robiul Islam **********
**** Date: 02 FEB 2017 *********
* <Rating>1396</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.I.ATM.ACC.CHK
*-----------------------------------------------------------------------------
* Modification History : RETROFIT from TAFC to TAFJ
* 1)
* Date :30/12/2023
* Modification Description :
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------
* Subroutine Description: This routine is used for ATM CARD MANAGEMENT SYSTEM to issue CARD from Branch User.
* Subroutine Type: INPUT
* Attached To    : EB.JBL.ATM.CARD.MGT,ISSUE
* Attached As    : INPUT ROUTINE
* TAFC Routine Name :ATM.ACC.CHK - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
* $INSERT I_F.ACCOUNT
    $USING AC.AccountOpening
* $INSERT I_F.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.PARAMETER
    $INSERT I_F.EB.JBL.ATM.MAINT.CALC
    $INSERT I_F.EB.JBL.CARD.OFF.INFO
* $INSERT I_F.CUSTOMER
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING EB.Interface
    $USING FT.Contract
    
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.CO.CODE = Y.ID.COMPANY[6,4]
    Y.TODAY = EB.SystemTables.getToday()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.APPLICATION = EB.SystemTables.getApplication()
    Y.APP.VERSION = Y.APPLICATION:Y.PGM.VERSION
    Y.COMP.OFSOPS = EB.Interface.getOfsOperation()
    
    Y.CARD.REC.STATUS = EB.SystemTables.getRNew(EB.ATM19.RECORD.STATUS)

    IF (Y.APP.VERSION EQ "EB.JBL.ATM.CARD.MGT,ISSUE") AND (Y.CARD.REC.STATUS EQ "IHLD") THEN
        EB.SystemTables.setE("Rec in HOLD Status, Please Create a New Deal")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

INIT:
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    FN.AC.HIS = "F.ACCOUNT$HIS"
    F.AC.HIS = ""
    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    FN.CARD.PARAM = "F.EB.JBL.ATM.CARD.PARAMETER"
    F.CARD.PARAM = ""
    FN.JBL.ATM.CALC = 'F.EB.JBL.ATM.MAINT.CALC'
    F.JBL.ATM.CALC = ''
    FN.CARD.OFF = "F.EB.JBL.CARD.OFF.INFO"
    F.CARD.OFF = ""
    
    Y.CARD.PARAM.ID = "SYSTEM"
    EB.DataAccess.Opf(FN.CARD.PARAM, F.CARD.PARAM)
    EB.DataAccess.FRead(FN.CARD.PARAM, Y.CARD.PARAM.ID, R.CARD.PARAM.REC, F.CARD.PARAM, Y.CARD.ERR)
    Y.CATEGORY.ALLOW = R.CARD.PARAM.REC<EB.JBL74.CATEGORY>
    Y.TITLE.LENGTH = R.CARD.PARAM.REC<EB.JBL74.TITLE.LENGTH>
        
    Y.ACCOUNT = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
* Y.CATEGORY.ALLOW = 1001:@FM:6001:@FM:6004:@FM:6019

    Y.DR.DT = Y.TODAY
    Y.DEBIT.ACCT.ID = Y.ACCOUNT
    
    Y.TR.CODE = "AC"
*---- S/D A/C: Fees for ATM Card Vendor --------*

    Y.CR.ACC.NUM.1 = "BDT172080001":Y.CO.CODE
    Y.D.AMT.1 = "250"
    Y.FT.COMM.1 = "CARDCRGBR"
    Y.ATM.COM.AMT.1 = "250"
*---- Income A/C: Card Maintenance Fee -----*
    Y.CR.ACC.NUM.2 = "PL52047"
    Y.D.AMT.2 = "250"
*---- S/D A/C Comm-VAT on ATM Card Vendor -------*
    Y.CR.ACC.NUM.3 = "BDT172570001":Y.CO.CODE
    Y.D.AMT.3 = "75"

    Y.CELLPHONE = ""
    Y.CLIENTPROPF = ""
    Y.CLIENTPROPM = ""
    Y.BIRTHDAY = ""
    Y.ADDRESS = ""
    Y.CORADDRESS = ""
    
    FN.ATM = "F.EB.JBL.ATM.CARD.MGT"
    F.ATM = ""
    
    FN.ATM.NAU = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    
    Y.CARD.TYPE = EB.SystemTables.getRNew(EB.ATM19.CARD.TYPE)
    Y.CARD.NAME = EB.SystemTables.getRNew(EB.ATM19.CARD.NAME)
    Y.CARD.ATTRIBUTE5 = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE5)
    Y.ID.NEW = EB.SystemTables.getIdNew()
    R.AC.REC = ""
    Y.FLAG = 0
    Y.MODE.FLAG = 0
    
OPENFILES:
*EB.DataAccess.Opf(YnameIn, YnameOut)
    EB.DataAccess.Opf(FN.AC, F.AC)
    EB.DataAccess.Opf(FN.AC.HIS, F.AC.HIS)
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    EB.DataAccess.Opf(FN.ATM, F.ATM)
    EB.DataAccess.Opf(FN.ATM.NAU, F.ATM.NAU)
    EB.DataAccess.Opf(FN.JBL.ATM.CALC, F.JBL.ATM.CALC)
    EB.DataAccess.Opf(FN.CARD.OFF, F.CARD.OFF)
RETURN

PROCESS:
    
    IF Y.ACCOUNT NE "" THEN
        EB.DataAccess.FRead(FN.AC,Y.ACCOUNT,R.AC.REC,F.AC,Y.ERR)
        Y.AC.CURR = R.AC.REC<AC.AccountOpening.Account.Currency>
        Y.CATEGORY.ACC = R.AC.REC<AC.AccountOpening.Account.Category>
        Y.JOINT.HOLDER = R.AC.REC<AC.AccountOpening.Account.JointHolder>
        Y.POSTING.RESTRICT = R.AC.REC<AC.AccountOpening.Account.PostingRestrict>
        Y.INACTIVE.MARKER = R.AC.REC<AC.AccountOpening.Account.InactivMarker>
        Y.CUSTOMER = R.AC.REC<AC.AccountOpening.Account.Customer>
*-----------------------ACCOUNT LT need to check--------------------------------------------*
        EB.Foundation.MapLocalFields('ACCOUNT', 'LT.MODE.OF.OPER', Y.MODE.OF.OPER.POS)
        EB.Foundation.MapLocalFields('ACCOUNT', 'LT.AC.NATURE', Y.ACCOUNT.NATURE.POS)
        Y.AC.MODE = UPCASE(R.AC.REC<AC.AccountOpening.Account.LocalRef, Y.MODE.OF.OPER.POS>)
        Y.AC.NATURE = UPCASE(R.AC.REC<AC.AccountOpening.Account.LocalRef, Y.ACCOUNT.NATURE.POS>)
        
        IF Y.AC.MODE EQ "SELF" OR Y.AC.MODE EQ "SINGLE" THEN
            Y.MODE.FLAG = 1
        END
        
        EB.DataAccess.FRead(FN.CUS,Y.CUSTOMER,R.CUS.REC,F.CUS,Y.ERR)
        Y.SEX = R.CUS.REC<ST.Customer.Customer.EbCusGender>
        Y.TITLE = R.CUS.REC<ST.Customer.Customer.EbCusTitle>

        FLD.POS = ""
        LOCAL.FIELDS = ""
* LOCAL.FIELDS = "LT.CUS.COMU.ADD":@VM:"LT.CUS.COMU.VILL":@VM:"LT.CUS.COMU.PO":@VM:"LT.CUS.COMU.UPZ":@VM:"LT.COMU.DIST":@VM:"LT.FATHER.NAME":@VM:"LT.MOTHER.NAME":@VM:"LT.SMS.ALERT"
        LOCAL.FIELDS = "LT.ADDR.TYPE":@VM:"LT.VILLAGE.AREA":@VM:"LT.POST.OFFICE":@VM:"LT.THANA":@VM:"LT.ZILLA":@VM:"LT.FATHER.NAME":@VM:"LT.MOTHER.NAME":@VM:"LT.SMS.ALERT"
        EB.Foundation.MapLocalFields("CUSTOMER", LOCAL.FIELDS, FLD.POS)
        Y.LT.CUS.COMU.ADD.POS = FLD.POS<1,1>
        Y.LT.CUS.COMU.VILL.POS = FLD.POS<1,2>
        Y.LT.CUS.COMU.PO.POS = FLD.POS<1,3>
        Y.LT.CUS.COMU.UPZ.POS = FLD.POS<1,4>
        Y.LT.CUS.COMU.DIST.POS = FLD.POS<1,5>
        Y.LT.FATHER.NAME.POS = FLD.POS<1,6>
        Y.LT.MOTHER.NAME.POS = FLD.POS<1,7>
        Y.LT.SMS.ALERT.POS = FLD.POS<1,8>
        
        Y.TOTAL.LT = R.CUS.REC<ST.Customer.Customer.EbCusLocalRef>
    
        Y.LT.CUS.COMU.ADD = Y.TOTAL.LT<1, Y.LT.CUS.COMU.ADD.POS>
        Y.LT.CUS.COMU.VILL = Y.TOTAL.LT<1, Y.LT.CUS.COMU.VILL.POS>
        Y.LT.CUS.COMU.PO = Y.TOTAL.LT<1, Y.LT.CUS.COMU.PO.POS>
        Y.LT.CUS.COMU.UPZ = Y.TOTAL.LT<1, Y.LT.CUS.COMU.UPZ.POS>
        Y.LT.CUS.COMU.DIST = Y.TOTAL.LT<1, Y.LT.CUS.COMU.DIST.POS>
        Y.LT.FATHER.NAME = Y.TOTAL.LT<1, Y.LT.FATHER.NAME.POS>
        Y.LT.MOTHER.NAME = Y.TOTAL.LT<1, Y.LT.MOTHER.NAME.POS>
        Y.LT.SMS.ALERT = Y.TOTAL.LT<1, Y.LT.SMS.ALERT.POS>

        Y.CELLPHONE = R.CUS.REC<ST.Customer.Customer.EbCusSmsOne>
        
        Y.CLIENTPROPF = Y.LT.FATHER.NAME
        Y.CLIENTPROPM = Y.LT.MOTHER.NAME
        Y.SMS.ALERT = Y.LT.SMS.ALERT
        
        Y.BIRTHDAY = R.CUS.REC<ST.Customer.Customer.EbCusDateOfBirth>
        Y.ADDRESS = R.CUS.REC<ST.Customer.Customer.EbCusStreet>
        Y.TOWN.COUNTRY = R.CUS.REC<ST.Customer.Customer.EbCusTownCountry>
        Y.CORADDRESS = Y.LT.CUS.COMU.ADD
        Y.COM.VILL = Y.LT.CUS.COMU.VILL
        Y.COM.PO = Y.LT.CUS.COMU.PO
        Y.COM.UPZ = Y.LT.CUS.COMU.UPZ
        Y.COM.DIST = Y.LT.CUS.COMU.DIST

        Y.CATEGORY.COUNT = DCOUNT(Y.CATEGORY.ALLOW, @VM)
        Y.CATE.CHK = 0
        
        FOR I=1 TO Y.CATEGORY.COUNT
            Y.CATE = FIELD(Y.CATEGORY.ALLOW, @VM, I)
            
            IF Y.CATE EQ Y.CATEGORY.ACC THEN
                Y.CATE.CHK = 1
                BREAK
            END
        NEXT I

        Y.MSG = "PLEASE GIVE INPUT-"
        
        IF R.AC.REC NE "" AND Y.SEX EQ "" THEN
            Y.MSG = Y.MSG :" Gender,"
            Y.FLAG = 1
        END
        
        IF R.AC.REC NE "" AND Y.TITLE EQ "" THEN
            Y.MSG = Y.MSG :" Title ,"
            Y.FLAG=1
        END
        
        IF R.AC.REC NE "" AND Y.CELLPHONE EQ "" THEN
            Y.MSG = Y.MSG :" Mobile Phone Numbers,"
            Y.FLAG=1
        END
*-------------- LT IS NOT AVAIABLE, RECOSIDER LT.SMS.ALERT After Decision -------------*
*        IF R.AC.REC NE "" AND Y.SMS.ALERT NE "Y" THEN
*            Y.MSG = Y.MSG :" SMS ALERT,"
*            Y.FLAG=1
*        END
*-------------- LT IS NOT AVAIABLE, RECOSIDER LT.SMS.ALERT After Decision -- END -----------*
        IF R.AC.REC NE "" AND Y.BIRTHDAY EQ "" THEN
            Y.MSG = Y.MSG :" Birthday,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.CLIENTPROPF EQ "" THEN
            Y.MSG = Y.MSG :" Father Name,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.CLIENTPROPM EQ "" THEN
            Y.MSG = Y.MSG :" Mother Name,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.ADDRESS EQ "" THEN
            Y.MSG = Y.MSG :"Present Address,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.TOWN.COUNTRY EQ "" THEN
            Y.MSG = Y.MSG :"Present Address-TOWN,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.CORADDRESS EQ "" THEN
            Y.MSG = Y.MSG :" Communication Address,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.COM.VILL EQ "" THEN
            Y.MSG = Y.MSG :" Communication Address-VILLAGE,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.COM.PO EQ "" THEN
            Y.MSG = Y.MSG :" Communication Address-POLICE STATION,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.COM.UPZ EQ "" THEN
            Y.MSG = Y.MSG :" Communication Address-THANA,"
            Y.FLAG=1
        END
        IF R.AC.REC NE "" AND Y.COM.DIST EQ "" THEN
            Y.MSG = Y.MSG :" Communication Address-DISTRICT,"
            Y.FLAG=1
        END
    
*--------------------- Generate Error ------------------------------------*
        IF R.AC.REC NE "" AND Y.INACTIVE.MARKER NE "" THEN

            EB.SystemTables.setEtext(Y.ACCOUNT: " INACTIVE ACCOUNT")
            EB.ErrorProcessing.StoreEndError()
        END

        ELSE IF Y.CATEGORY.ACC NE "" AND Y.CATE.CHK EQ 0 THEN
            EB.SystemTables.setEtext("INVALID CATEGORY")
            EB.ErrorProcessing.StoreEndError()
        END

        ELSE IF LEN(Y.CARD.NAME) LT 3 THEN
            EB.SystemTables.setEtext("CARD NAME MUST BE MINIMUM OF 3 CHARACTERS")
            EB.ErrorProcessing.StoreEndError()
        END
    
        ELSE IF R.AC.REC NE "" AND Y.ID.COMPANY NE R.AC.REC<AC.AccountOpening.Account.CoCode> THEN
            EB.SystemTables.setEtext(Y.ACCOUNT: " INVALID ACCOUNT")
            EB.ErrorProcessing.StoreEndError()

        END
        ELSE IF R.AC.REC NE "" AND Y.JOINT.HOLDER NE "" THEN
            EB.SystemTables.setEtext("JOINT ACCOUNT IS NOT ALLOWED")
            EB.ErrorProcessing.StoreEndError()
        END
        ELSE IF Y.CUSTOMER EQ "" THEN
            EB.SystemTables.setEtext("CUSTOMER IS MISSING")
            EB.ErrorProcessing.StoreEndError()
        END
        ELSE IF NOT(ISDIGIT(Y.ACCOUNT)) THEN
            EB.SystemTables.setEtext("INVALID ACCOUNT")
            EB.ErrorProcessing.StoreEndError()
        END
*        ELSE IF Y.AC.MODE NE "" AND Y.MODE.FLAG EQ 0 THEN
*            EB.SystemTables.setEtext("INDIVIDUAL ACCOUNT ALLOW MODE OF OPERATION MUST BE SELF")
*            EB.ErrorProcessing.StoreEndError()
*        END
*        ELSE IF Y.AC.NATURE NE "" AND Y.AC.NATURE NE "INDIVIDUAL ACCOUNT" THEN
*            EB.SystemTables.setEtext("INDIVIDUAL ACCOUNT ALLOW ACCOUNT NATURE MUST BE INDIVIDUAL ACCOUNT")
*            EB.ErrorProcessing.StoreEndError()
*        END


        ELSE IF Y.POSTING.RESTRICT NE "" AND R.AC.REC NE "" THEN
            EB.SystemTables.setEtext(Y.ACCOUNT: " IS POSTING RESTRICTED")
            EB.ErrorProcessing.StoreEndError()
        END
        ELSE IF Y.FLAG EQ 1 THEN
            Y.MSG = Y.MSG :" Field This Customer(":Y.CUSTOMER:") Module"
            EB.SystemTables.setEtext(Y.MSG)
            EB.ErrorProcessing.StoreEndError()
        END
        ELSE IF LEN(Y.CELLPHONE<1,1>) LE 10 THEN
            Y.MSG = "Invalid Mobile Number This Customer(":Y.CUSTOMER:") Module"
            EB.SystemTables.setEtext(Y.MSG)
            EB.ErrorProcessing.StoreEndError()
        END
        ELSE IF R.AC.REC NE "" THEN
            SEL.CMD = "SELECT ":FN.ATM:" WITH ACCT.NO EQ " : Y.ACCOUNT
            CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)
            LOOP
                REMOVE Y.ATM.ID FROM SEL.LIST SETTING Y.POS
            WHILE Y.ATM.ID:Y.POS
                EB.DataAccess.FRead(FN.ATM,Y.ATM.ID,R.ATM.REC,F.ATM,Y.ERR)
                IF ((R.ATM.REC<EB.ATM19.CARD.TYPE> EQ Y.CARD.TYPE) AND (Y.ATM.ID NE Y.ID.NEW)) THEN
                    
********--------------------------TRACER------------------------------------------------------------------------------
                    WriteData = "GB.JBL.I.ATM.ACC.CHK = TRIGGERED"
                    FileName = 'SHIBLI_ATM.txt'
                    FilePath = 'DL.BP'
                    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
                    ELSE
                        CREATE FileOutput ELSE
                        END
                    END
                    WRITESEQ WriteData APPEND TO FileOutput ELSE
                        CLOSESEQ FileOutput
                    END
                    CLOSESEQ FileOutput
********--------------------------TRACER-END--------------------------------------------------------*********************

                    EB.SystemTables.setEtext(Y.ACCOUNT: " IS ALREADY ASSIGNED THIS TYPE OF CARD")
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                END
            REPEAT

            SEL.CMD = "SELECT ":FN.ATM.NAU:" WITH ACCT.NO EQ " : Y.ACCOUNT
            CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)
            LOOP
                REMOVE Y.ATM.ID FROM SEL.LIST SETTING Y.POS
            WHILE Y.ATM.ID:Y.POS
                EB.DataAccess.FRead(FN.ATM.NAU,Y.ATM.ID,R.ATM.REC,F.ATM.NAU,Y.ERR)
                IF ((R.ATM.REC<EB.ATM19.CARD.TYPE> EQ Y.CARD.TYPE) AND (Y.ATM.ID NE Y.ID.NEW)) THEN
                    EB.SystemTables.setEtext(Y.ACCOUNT: " IS ALREADY ASSIGNED THIS TYPE OF CARD")
                    EB.ErrorProcessing.StoreEndError()
                    BREAK
                END
            REPEAT
        END
        
********--------------------------TRACER------------------------------------------------------------------------------
        WriteData = "GB.JBL.I.ATM.ACC.CHK = R.ATM.REC: ":R.ATM.REC:" Y.CARD.TYPE: ":Y.CARD.TYPE:" Y.ATM.ID: ":Y.ATM.ID:" Y.ID.NEW :":Y.ID.NEW
        FileName = 'SHIBLI_ATM.txt'
        FilePath = 'DL.BP'
        OPENSEQ FilePath,FileName TO FileOutput THEN NULL
        ELSE
            CREATE FileOutput ELSE
            END
        END
        WRITESEQ WriteData APPEND TO FileOutput ELSE
            CLOSESEQ FileOutput
        END
        CLOSESEQ FileOutput
********--------------------------TRACER-END--------------------------------------------------------*********************
        
        
        
        Y.COUNT = DCOUNT(Y.CARD.NAME, " ")
        FOR I=1 TO Y.COUNT
            IF NOT(ALPHA(FIELD(Y.CARD.NAME, " ", I))) THEN
                EB.SystemTables.setEtext("PLEASE REMOVE SPECIAL CHARACTER FROM CARD NAME")
                EB.ErrorProcessing.StoreEndError()
            END
        NEXT I
    
        Y.NAME.COUNT = DCOUNT(Y.CARD.NAME, "") - 1
        IF Y.NAME.COUNT GT Y.TITLE.LENGTH THEN
            EB.SystemTables.setE("CARD Name: Length must be less than or equal to ":Y.TITLE.LENGTH:" Characters")
            EB.ErrorProcessing.StoreEndError()
        END
        
********--------------------------TRACER------------------------------------------------------------------------------
        WriteData = "GB.JBL.I.ATM.ACC.CHK = Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
        FileName = 'SHIBLI_ATM.txt'
        FilePath = 'DL.BP'
        OPENSEQ FilePath,FileName TO FileOutput THEN NULL
        ELSE
            CREATE FileOutput ELSE
            END
        END
        WRITESEQ WriteData APPEND TO FileOutput ELSE
            CLOSESEQ FileOutput
        END
        CLOSESEQ FileOutput
********--------------------------TRACER-END--------------------------------------------------------*********************

*IF Y.COMP.OFSOPS EQ "VALIDATE" THEN
*        RETURN
*    END

*----------------DEBIT FROM CUS ACC USING OFS --------------------------------------------------------
        IF (Y.APP.VERSION EQ "EB.JBL.ATM.CARD.MGT,ISSUE") AND (Y.COMP.OFSOPS EQ "PROCESS") AND (Y.VFUNCTION EQ "I") THEN
            Y.JBL.ATM.CALC = "ISSUE"
            EB.DataAccess.FRead(FN.JBL.ATM.CALC, Y.JBL.ATM.CALC, JBL.ATM.CALC.REC, F.JBL.ATM.CALC, JBL.ATM.CALC.ERR)
            Y.INCLUDE.CATEGORY = JBL.ATM.CALC.REC<EB.ATM.MAINT.INCLUDE.CATEGORY>
            Y.TRN.TYPE = JBL.ATM.CALC.REC<EB.ATM.MAINT.TRANSACTION.TYPE>
        
            FIND Y.CATEGORY.ACC IN Y.INCLUDE.CATEGORY SETTING Y.POS1, Y.POS2 THEN
                Y.TRN.TYPE = JBL.ATM.CALC.REC<EB.ATM.MAINT.TRANSACTION.TYPE>
                Y.TR.CODE = Y.TRN.TYPE
                Y.VEN.ACT = JBL.ATM.CALC.REC<EB.ATM.MAINT.VEN.ACCT, Y.POS2>
                Y.VEN.AMT = JBL.ATM.CALC.REC<EB.ATM.MAINT.VEN.CHARGE.AMT, Y.POS2>
                
                Y.CR.ACC.NUM.1 = Y.VEN.ACT
                Y.D.AMT.1 = Y.VEN.AMT
        
                EB.DataAccess.FRead(FN.CARD.OFF, Y.ACCOUNT, REC.OFF, F.CARD.OFF, ERR.OFF)
                Y.CARD.OFFER.VAL = REC.OFF<EB.JBL.CARD.OFF.CARD.OFFER>
                IF Y.CARD.OFFER.VAL NE "50Percent" THEN
                    Y.CHRG.TYPE = JBL.ATM.CALC.REC<EB.ATM.MAINT.CHARGE.TYPE, Y.POS2>
                    Y.BR.CHRG.AMT = JBL.ATM.CALC.REC<EB.ATM.MAINT.BRANCH.CHARGE.AMT, Y.POS2>
                    Y.FT.COMM = JBL.ATM.CALC.REC<EB.ATM.MAINT.FT.COMM.TYPE, Y.POS2>
                    Y.FT.COMM.1 = Y.FT.COMM
                    Y.ATM.COM.AMT = JBL.ATM.CALC.REC<EB.ATM.MAINT.FT.COMM.AMT, Y.POS2>
                    Y.ATM.COM.AMT.1 = Y.ATM.COM.AMT
                    Y.VAT.PER = JBL.ATM.CALC.REC<EB.ATM.MAINT.VAT.PERCENT, Y.POS2>
                END
            END
    
            KOfsSource1 = "CARD.OFS"
            
            OfsMessage<FT.Contract.FundsTransfer.TransactionType> = Y.TR.CODE
            OfsMessage<FT.Contract.FundsTransfer.DebitAcctNo> = Y.DEBIT.ACCT.ID
            OfsMessage<FT.Contract.FundsTransfer.DebitCurrency> = Y.AC.CURR
            OfsMessage<FT.Contract.FundsTransfer.DebitAmount> = Y.D.AMT.1
            OfsMessage<FT.Contract.FundsTransfer.DebitValueDate> = Y.DR.DT
            OfsMessage<FT.Contract.FundsTransfer.CreditAcctNo> = Y.CR.ACC.NUM.1
            
            IF Y.ATM.COM.AMT NE "" THEN
                OfsMessage<FT.Contract.FundsTransfer.CommissionCode> = "DEBIT PLUS CHARGES"
                OfsMessage<FT.Contract.FundsTransfer.CommissionType> = Y.FT.COMM.1
                OfsMessage<FT.Contract.FundsTransfer.CommissionAmt> = "BDT":Y.ATM.COM.AMT
            END
********--------------------------TRACER------------------------------------------------------------------------------
            WriteData = "GB.JBL.I.ATM.ACC.CHK = INSIDE OFS BLOCK: Y.VFUNCTION: ":Y.VFUNCTION:" Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
            FileName = 'SHIBLI_ATM.txt'
            FilePath = 'DL.BP'
            OPENSEQ FilePath,FileName TO FileOutput THEN NULL
            ELSE
                CREATE FileOutput ELSE
                END
            END
            WRITESEQ WriteData APPEND TO FileOutput ELSE
                CLOSESEQ FileOutput
            END
            CLOSESEQ FileOutput
********--------------------------TRACER-END--------------------------------------------------------*********************

*    IF Y.REQUEST.TYPE EQ "PINREISSUE" OR Y.REQUEST.TYPE EQ "CLOSE" THEN
*        R.NEW(FT.COMMISSION.CODE)="DEBIT PLUS CHARGES"
*        R.NEW(FT.COMMISSION.TYPE)=Y.FT.COMM
*    END
            
*---------------- OFS for S/D A/C: Fees for ATM Card Vendor --------*
            Ofsrecord = ''
            EB.Foundation.OfsBuildRecord("FUNDS.TRANSFER", "I", "PROCESS", "FUNDS.TRANSFER,JBL.ATM.OFS.AC", "", 1, "", OfsMessage, Ofsrecord)
            EB.Interface.OfsGlobusManager(KOfsSource1, Ofsrecord)
            T24TxnRef = FIELD(Ofsrecord, '/', 1)
            
            IF T24TxnRef NE "" THEN
                EB.SystemTables.setRNew(EB.ATM19.ATTRIBUTE5, T24TxnRef)
            END

********--------------------------TRACER------------------------------------------------------------------------------
            WriteData = "GB.JBL.I.ATM.ACC.CHK =":" Ofsrecord: ":Ofsrecord:" OfsMessage: ":OfsMessage:" T24TxnRef: ":T24TxnRef:" Y.VFUNCTION: ":Y.VFUNCTION:" Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
            FileName = 'SHIBLI_ATM.txt'
            FilePath = 'DL.BP'
            OPENSEQ FilePath,FileName TO FileOutput THEN NULL
            ELSE
                CREATE FileOutput ELSE
                END
            END
            WRITESEQ WriteData APPEND TO FileOutput ELSE
                CLOSESEQ FileOutput
            END
            CLOSESEQ FileOutput
********--------------------------TRACER-END--------------------------------------------------------*********************
            
**---------------- Income A/C: Card Maintenance Fee -----*
*            KOfsSource2 = "OFS.LOAD.2"
*            OfsMessage<FT.Contract.FundsTransfer.DebitAmount> = Y.D.AMT.2
*            OfsMessage<FT.Contract.FundsTransfer.CreditAcctNo> = Y.CR.ACC.NUM.2
** Ofsrecord = ''
*
*            EB.Foundation.OfsBuildRecord("FUNDS.TRANSFER", "I", "PROCESS", "FUNDS.TRANSFER,JBL.ATM.OFS.AC.2", "", 0, "", OfsMessage, Ofsrecord)
*            EB.Interface.OfsGlobusManager(KOfsSource2, Ofsrecord)
**            EB.Interface.OfsCallBulkManager(KOfsSource2, OfsMessage, OFS.RES, TXN.VAL)
*
*********--------------------------TRACER------------------------------------------------------------------------------
**  WriteData = "GB.JBL.I.ATM.ACC.CHK =":" KOfsSource2: ":KOfsSource2:" OfsMessage: ":OfsMessage:" OFS.RES: ":OFS.RES:" TXN.VAL: ":TXN.VAL:" Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
*            WriteData = "GB.JBL.I.ATM.ACC.CHK =":" Ofsrecord: ":Ofsrecord:" OfsMessage: ":OfsMessage:" Y.GET.MESSAGE: ":Y.GET.MESSAGE:" Y.VACTION: ":Y.VACTION:" T24TxnRef: ":T24TxnRef:" Y.VFUNCTION: ":Y.VFUNCTION:" Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
*            FileName = 'SHIBLI_ATM.txt'
*            FilePath = 'D:/Temenos/t24home/default/DL.BP'
*            OPENSEQ FilePath,FileName TO FileOutput THEN NULL
*            ELSE
*                CREATE FileOutput ELSE
*                END
*            END
*            WRITESEQ WriteData APPEND TO FileOutput ELSE
*                CLOSESEQ FileOutput
*            END
*            CLOSESEQ FileOutput
*********--------------------------TRACER-END--------------------------------------------------------*********************
            
**---------------- S/D A/C Comm-VAT on ATM Card Vendor -------*
*            KOfsSource3 = "OFS.LOAD.3"
*            OfsMessage<FT.Contract.FundsTransfer.DebitAmount> = Y.D.AMT.3
*            OfsMessage<FT.Contract.FundsTransfer.CreditAcctNo> = Y.CR.ACC.NUM.3
** Ofsrecord = ''
*            EB.Foundation.OfsBuildRecord("FUNDS.TRANSFER", "I", "PROCESS", "FUNDS.TRANSFER,JBL.ATM.OFS.AC.3", "", 0, "", OfsMessage, Ofsrecord)
*            EB.Interface.OfsGlobusManager(KOfsSource3, Ofsrecord)
**            EB.Interface.OfsCallBulkManager(KOfsSource3, OfsMessage, OFS.RES, TXN.VAL)
*
*********--------------------------TRACER------------------------------------------------------------------------------
** WriteData = "GB.JBL.I.ATM.ACC.CHK =":" KOfsSource3: ":KOfsSource3:" OfsMessage: ":OfsMessage:" OFS.RES: ":OFS.RES:" TXN.VAL: ":TXN.VAL:" Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
*            WriteData = "GB.JBL.I.ATM.ACC.CHK =":" Ofsrecord: ":Ofsrecord:" OfsMessage: ":OfsMessage:" Y.GET.MESSAGE: ":Y.GET.MESSAGE:" Y.VACTION: ":Y.VACTION:" T24TxnRef: ":T24TxnRef:" Y.VFUNCTION: ":Y.VFUNCTION:" Y.COMP.OFSOPS: ":Y.COMP.OFSOPS
*            FileName = 'SHIBLI_ATM.txt'
*            FilePath = 'D:/Temenos/t24home/default/DL.BP'
*            OPENSEQ FilePath,FileName TO FileOutput THEN NULL
*            ELSE
*                CREATE FileOutput ELSE
*                END
*            END
*            WRITESEQ WriteData APPEND TO FileOutput ELSE
*                CLOSESEQ FileOutput
*            END
*            CLOSESEQ FileOutput
*********--------------------------TRACER-END--------------------------------------------------------*********************
        END
        RETURN
    END

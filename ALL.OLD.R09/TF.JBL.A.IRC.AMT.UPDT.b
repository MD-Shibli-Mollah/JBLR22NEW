SUBROUTINE TF.JBL.A.IRC.AMT.UPDT
*-----------------------------------------------------------------------------
*Subroutine Description: IRC amount update in Customer from LC
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version
*------------------------------------------LETTER.OF.CREDIT,JBL.BTBAMDEXT
*------------------------------------------LETTER.OF.CREDIT,JBL.BTBAMDINT
*------------------------------------------LETTER.OF.CREDIT,JBL.BTBSIGHT
*------------------------------------------LETTER.OF.CREDIT,JBL.BTBUSANCE
*------------------------------------------LETTER.OF.CREDIT,JBL.EDFOPEN
*------------------------------------------LETTER.OF.CREDIT,JBL.IMAMDEXT
*------------------------------------------LETTER.OF.CREDIT,JBL.IMAMDINT
*------------------------------------------LETTER.OF.CREDIT,JBL.IMPSIGHT
*------------------------------------------LETTER.OF.CREDIT,JBL.IMPUSANCE
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 02/04/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
* Modification History :
* 11/12/2020 -                            CREATE   - Shajjad Hossen,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
     
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING LC.Contract
    $USING ST.Customer
    $USING LC.Config
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    FN.LC.TYPE = "F.LC.TYPES"
    F.LC.TYPE = ""
    
    EB.LocalReferences.GetLocRef("CUSTOMER","LT.TF.AVL.LIMIT",Y.IRC.LC.AMOUNT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.IRC.LIMIT",Y.IRC.LIMIT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.VER.NAME",Y.LT.VER.NAME.POS)
    EB.LocalReferences.GetLocRef("LC.TYPES","LT.LCTP.LOC.FRG",Y.LCTYPE.LOC.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    EB.DataAccess.Opf(FN.LC.TYPE, F.LC.TYPE)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.IRC.LIMIT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1, Y.IRC.LIMIT.POS>
    
    IF Y.IRC.LIMIT ELSE RETURN
    Y.LC.TYPE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcType)
    EB.DataAccess.FRead(FN.LC.TYPE,Y.LC.TYPE,R.LC.TYPE,F.LC.TYPE,Y.LC.ERR)
    Y.LOC.FOR = R.LC.TYPE<LC.Config.Types.TypLocalRef, Y.LCTYPE.LOC.POS>
    
    IF R.LC.TYPE THEN
        Y.LOC.FOR = R.LC.TYPE<LC.Config.Types.TypLocalRef, Y.LCTYPE.LOC.POS>
    END
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    IF Y.LOC.FOR EQ "FOREIGN" THEN
        IF Y.IRC.LIMIT ELSE RETURN
        Y.EX.RT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcOrigRate)
        Y.CUS.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
        EB.DataAccess.FRead(FN.CUS, Y.CUS.ID, R.CUS, F.CUS, E.CUS)
*********************************************************************
        IF R.CUS THEN
            Y.CUS.LC.AMOUNT = R.CUS<ST.Customer.Customer.EbCusLocalRef, Y.IRC.LC.AMOUNT.POS>
            Y.LC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
            Y.LC.AMOUNT *= Y.EX.RT
            Y.NEW.LC.AMOUNT = Y.CUS.LC.AMOUNT + Y.LC.AMOUNT
            Y.VER.NAME = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1, Y.LT.VER.NAME.POS>
*====================================================
            IF Y.VER.NAME EQ "JBL.IMAMDEXT" OR Y.VER.NAME EQ "JBL.IMAMDINT" OR Y.VER.NAME EQ "JBL.BTBAMDINT" OR Y.VER.NAME EQ "JBL.BTBAMDEXT"  THEN
                Y.AM.LC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
                Y.OLD.LC.AMOUNT = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
                Y.DIFF.LC = Y.AM.LC.AMOUNT - Y.OLD.LC.AMOUNT
*-----------------------------------------
                IF Y.DIFF.LC GT '0' THEN
                    Y.DIFF.LC *= Y.EX.RT
                    Y.NEW.LC.AMOUNT = Y.CUS.LC.AMOUNT + Y.DIFF.LC
                END
                ELSE
                    RETURN
                END
*-----------------------------------------
            END
*====================================================
        END
*********************************************************************
        R.CUS<ST.Customer.Customer.EbCusLocalRef, Y.IRC.LC.AMOUNT.POS> = DROUND(Y.NEW.LC.AMOUNT,4)
        EB.DataAccess.FWrite(FN.CUS, Y.CUS.ID, R.CUS)
    END
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
RETURN
*** </region>
END
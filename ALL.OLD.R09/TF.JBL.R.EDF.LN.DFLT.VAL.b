SUBROUTINE TF.JBL.R.EDF.LN.DFLT.VAL
*-----------------------------------------------------------------------------
* Attached Activity.Api - JBL.TF.EDF.API
* Modification History :
* 10/06/2020 -                            Retrofit   - MAHMUDUR RAHMAN UDOY,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
*Description: this routine auto-populate the Term property maturity date.
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Account
    $USING EB.API
    $USING EB.Utility
    $USING EB.Updates

    

   
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
    
    
    Y.APP="AA.ARR.ACCOUNT"
    Y.FLDS="LT.AC.BD.LNMADT":VM:"LT.AC.REFIN.PRD"
    Y.POS= ''
 
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.LNMADT.POS  = Y.POS<1,1>
    Y.BB.REF.PROD.POS = Y.POS<1,2>

    
RETURN
   
OPENFILE:
    
    EB.DataAccess.Opf(FN.ARR, F.ARR)
   
RETURN
   
PROCESS:

    Y.EFF.DATE = AA.Framework.getC_aalocactivityeffdate()
 
    Y.DAYS = '179D'
    EB.Utility.CalendarDay(Y.EFF.DATE, '+', Y.DAYS)

           
    Y.TEMP = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.TEMP<1,Y.LNMADT.POS> = Y.DAYS
    Y.TEMP<1,Y.BB.REF.PROD.POS> = 'Y'
    EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, Y.TEMP)
       
     
RETURN

 
END